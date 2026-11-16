

# Horizontal Pod Autoscaler (HPA)

[![Video: Kubernetes – Horizontal Pod Autoscaler (HPA)](https://img.youtube.com/vi/5s_R9QDLUgg/maxresdefault.jpg)](https://youtu.be/5s_R9QDLUgg)

## 1. What is HPA and Why Do We Need It?

The **Horizontal Pod Autoscaler** is a Kubernetes controller that automatically adjusts the **number of pod replicas** in a Deployment, StatefulSet, or ReplicaSet based on observed workload metrics (CPU, memory, or custom metrics via the Metrics API).  This ensures:

* **Elastic capacity** – applications scale out during traffic spikes and scale in when demand drops, saving cluster resources and cost.
* **Help with SLAs** – helps keep response‑time and throughput targets under changing load, without manual intervention (measure them to know).
* **Operational simplicity** – ops teams define policies once; the controller handles continuous scaling.

## 2. When to Use HPA – Practical Examples

| Scenario                                                                    | Why HPA Helps                                                                            |
| --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Web front‑end with unpredictable traffic (marketing campaigns, flash sales) | Automatically adds pods to keep latency low under sudden load.                           |
| CPU‑bound background workers (image/video processing)                       | Scales workers up when job queue grows, preventing backlog buildup.                      |
| Event‑driven micro‑services consuming from Kafka/RabbitMQ                   | Matches consumer replica count to message throughput, avoiding lag or over‑provisioning. |
| SaaS multi‑tenant API                                                       | Scales by tenant load patterns while keeping baseline footprint small off‑peak.          |

## 3. Technical Background – How It Works

1. **Metrics Collection**

   * The **Metrics Server** collects pod CPU and memory usage from the kubelets and serves it through the resource Metrics API (`metrics.k8s.io`).
   * Custom and external metrics (for example queue length or Kafka lag) need an adapter, such as the Prometheus Adapter, that serves `custom.metrics.k8s.io` or `external.metrics.k8s.io`.
2. **HPA Controller Loop**

   * Every 15 seconds (configurable) the HPA controller compares current metric values to the **target** (e.g., 50% CPU).
   * Desired replicas `= ceil(currentReplicas × currentMetric / targetMetric)`, kept between min and max. A difference of up to 10% from the target is ignored (the default tolerance).
3. **Why Set Resource *Requests/Limits***

   * A CPU target in percent means percent of the **CPU request**: with a 200m request, 50% is 100m per pod on average. If a container has no CPU request, the HPA can't compute the percentage and won't scale on CPU.
   * The scheduler places pods by their requests. A limit caps what a container may use: CPU above the limit is throttled.
4. **Cooldowns & Stabilization**

   * Scaling up has no stabilization window by default: once the metric is above the target (beyond the tolerance), the next control loop adds pods, within the scale-up rate policy.
   * Scaling down has a 5-minute stabilization window by default: the HPA uses the highest recommendation of the last 5 minutes, so replicas drop only after the load has stayed low. This prevents flapping.

## 4. Hands‑On Lab – Autoscaling `php‑apache`

Follow these steps to observe HPA in action. You need `kubectl` and a cluster with **at least two schedulable nodes** (for the two Metrics Server replicas).

### Step 0 – Install the Metrics Server

The HPA reads CPU usage from the Metrics API, which the Metrics Server provides. If `kubectl top nodes` already works in your cluster, skip this step. Otherwise, install it in high-availability mode:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
```

This manifest runs **two replicas that must run on different nodes**, which is why the cluster needs two nodes that can run pods.

Verify that both replicas are ready and that the Metrics API answers:

```bash
kubectl -n kube-system get pods -l k8s-app=metrics-server -o wide
kubectl top nodes
```

> **Notes**
> * The command installs the **latest** release. Metrics Server 0.9.x officially supports Kubernetes 1.34+ ([compatibility matrix](https://github.com/kubernetes-sigs/metrics-server#compatibility-matrix)); on an older cluster it may fail. This lab was recorded on Kubernetes 1.32 with Metrics Server 0.9.1, and it worked.
> * On local clusters such as kind, the Metrics Server may fail to verify the kubelet certificates. For a practice cluster only, see the [Metrics Server FAQ](https://github.com/kubernetes-sigs/metrics-server/blob/master/FAQ.md) (`--kubelet-insecure-tls`).

### Step 1 – Deploy the Workload

Apply [`01-php-apache.yaml`](01-php-apache.yaml) from this folder: a Deployment with one replica and a Service on port 80.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  replicas: 1
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - name: php-apache
        image: registry.k8s.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: 500m
          requests:
            cpu: 200m
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache
  labels:
    run: php-apache
spec:
  ports:
  - port: 80
  selector:
    run: php-apache
```

```bash
kubectl apply -f 01-php-apache.yaml
kubectl rollout status deployment/php-apache
kubectl get deploy php-apache
```

*The manifest requests 200m CPU: the HPA's CPU percentage is based on this request. The 500m limit caps each pod.* The first image pull can take a few minutes.

### Step 2 – Create an HPA

```bash
kubectl autoscale deployment php-apache --cpu=50% --min=1 --max=6
```

> With kubectl older than 1.34, use `--cpu-percent=50` instead of `--cpu=50%` (from 1.34, `--cpu-percent` is deprecated).

Check HPA status. Until the first CPU reading arrives, TARGETS shows `<unknown>`; wait for a number (for example `cpu: 0%/50%`) before you start the load:

```bash
kubectl get hpa php-apache
```

### Step 3 – Generate Load

In a **second terminal**, start a pod that calls the service in a loop:

```bash
kubectl run -i --tty load-generator --rm \
  --image=busybox:1.28 --restart=Never -- \
  /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

Back in the first terminal, watch the HPA (press Ctrl+C to stop watching):

```bash
kubectl get hpa php-apache -w
```

To see the new pods and the nodes they run on, use a third terminal (or stop the watch first):

```bash
kubectl get pods -o wide
```

### Step 4 – Stop the Load and Watch the Scale-Down

Press **Ctrl+C** in the load-generator terminal. Because of `--rm`, the pod is deleted. Check that it's gone (if it's still there, delete it: `kubectl delete pod load-generator`):

```bash
kubectl get pods
kubectl get hpa php-apache -w
```

What to expect: CPU drops first. The replicas stay up while the high recommendations of the last 5 minutes (the default scale-down window) are still in the window, and then go down. Stop watching when REPLICAS is back to 1.

### Cleanup

```bash
kubectl delete hpa php-apache
kubectl delete -f 01-php-apache.yaml
```

The Metrics Server stays in the cluster. To remove it too, run `kubectl delete -f` with the same URL as in Step 0.

**Optional Extended Task:** Modify the Deployment to include a memory request/limit, delete the CPU HPA, and create an HPA that scales on memory utilization instead. Check that your load really raises memory usage (`kubectl top pods`), or the HPA will be correct but never scale.

---


---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="../docs/Chapter-16.md">Kubernetes Permissions</A>
