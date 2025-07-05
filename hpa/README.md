

# Horizontal Pod Autoscaler (HPA)

## 1. What is HPA and Why Do We Need It?

The **Horizontal Pod Autoscaler** is a Kubernetes controller that automatically adjusts the **number of pod replicas** in a Deployment, StatefulSet, or ReplicaSet based on observed workload metrics (CPU, memory, or custom metrics via the Metrics API).  This ensures:

* **Elastic capacity** – applications scale out during traffic spikes and scale in when demand drops, saving cluster resources and cost.
* **SLA adherence** – maintaining response‑time and throughput targets without manual intervention.
* **Operational simplicity** – ops teams define policies once; the controller handles continuous scaling.

## 2. When to Use HPA – Practical Examples

| Scenario                                                                    | Why HPA Helps                                                                            |
| --------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Web front‑end with unpredictable traffic (marketing campaigns, flash sales) | Automatically adds pods to keep latency low under sudden load.                           |
| CPU‑bound background workers (image/video processing)                       | Scales workers up when job queue grows, preventing backlog buildup.                      |
| Event‑driven micro‑services consuming from Kafka/RabbitMQ                   | Matches consumer replica count to message throughput, avoiding lag or over‑provisioning. |
| SaaS multi‑tenant API                                                       | Scales by tenant load patterns while keeping baseline footprint small off‑peak.          |

## 3. Technical Background – How It Works

1. **Metrics Collection**

   * The **Metrics Server** (or Prometheus adapter for custom metrics) scrapes pod‑level resource usage and exposes it via the Kubernetes Metrics API.
2. **HPA Controller Loop**

   * Every 15 seconds (configurable) the HPA controller compares current metric values to the **target** (e.g., 50 % CPU).
   * Desired replicas `= currentReplicas × currentMetric / targetMetric` (capped by min/max).
3. **Why Set Resource *Requests/Limits***

   * HPA uses **requested CPU** when calculating percentages; without requests, autoscaling cannot accurately decide when to add replicas.
   * Limits protect nodes from exhaustion and give predictable scheduling so scaling decisions are meaningful.
4. **Cooldowns & Stabilization**

   * Kubernetes adds delay windows to avoid flapping (rapid scale up/down).

## 4. Hands‑On Lab – Autoscaling `php‑apache`

Follow these steps to observe HPA in action.

### Step 1 – Deploy the Workload

create and apply the following file `php-apache.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  replicas: 3
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - name: php-apache
        image: k8s.gcr.io/hpa-example
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

or run kubectl apply -f https://k8s.io/examples/application/php-apache.yaml
 

*The manifest requests 200 m CPU and limits 500 m (critical for HPA).*  Verify:

```bash
kubectl get deploy php-apache
```

### Step 2 – Create an HPA

```bash
kubectl autoscale deployment php-apache \
  --cpu-percent=50 --min=1 --max=10
```

Check HPA status:

```bash
kubectl get hpa php-apache -w
```

### Step 3 – Generate Load

```bash
kubectl run -i --tty load-generator --rm \
  --image=busybox:1.28 --restart=Never -- \
  /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

Observe pods scaling with:

```bash
watch kubectl get pods,hpa
```

### Cleanup

```bash
kubectl delete deploy php-apache
kubectl delete svc php-apache
kubectl delete hpa php-apache
```

**Optional Extended Task:** Modify the Deployment to include a memory request/limit and create an HPA that scales on memory utilization instead of CPU.

---


---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="../docs/Chapter-16.md">Kubernetes Permissions</A>
