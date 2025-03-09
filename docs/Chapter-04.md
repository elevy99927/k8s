# Namespaces and Resource Management

## Why Use Namespaces?

Namespaces provide a way to logically partition a Kubernetes cluster into multiple virtual clusters. This is useful for:

- **Multi-Tenancy**: Isolating resources between teams, applications, or environments (e.g., dev, staging, prod).
- **Resource Management**: Applying quotas and limits to control resource consumption.
- **Organizing Workloads**: Avoiding naming conflicts by grouping resources under different namespaces.

## Default Namespaces in Kubernetes

Kubernetes comes with a few default namespaces:

- `default` – Used when no namespace is specified.
- `kube-system` – Contains system-critical Kubernetes components.
- `kube-public` – Accessible by all users, often used for public cluster information.
- `kube-node-lease` – Stores node lease information to improve node heartbeats.

## Creating and Managing Namespaces

You can create a new namespace using YAML or the command line.

### **Creating a Namespace via Command Line**

```sh
kubectl create namespace my-namespace
```

### **Creating a Namespace via YAML**

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: my-namespace
```

Apply the namespace:

```sh
kubectl apply -f namespace.yaml
```

### **Listing and Switching Namespaces**

To list all namespaces:

```sh
kubectl get namespacesAssigning Resource Quotas and Limits
```

Namespaces allow administrators to set quotas and limits on resource consumption. Additionally, Kubernetes provides different **Pod Quality of Service (QoS) classes** that help optimize resource allocation.

### **Pod Quality of Service (QoS) Classes**
Kubernetes assigns Pods a **QoS class** based on their resource requests and limits:

- **Guaranteed**: Assigned when all containers in the Pod have **both** CPU and memory limits **equal to** their requests. These Pods get the highest priority during resource contention.
- **Burstable**: Assigned when at least one container has **requests lower than limits**. These Pods can burst beyond their initial allocation if resources are available.
- **BestEffort**: Assigned when a Pod **has no resource requests or limits**. These Pods get the lowest priority and are the first to be evicted when the cluster is under pressure.

To check the QoS class of a running Pod:
```sh
kubectl get pod limited-pod -o jsonpath='{.status.qosClass}'
```

### **Example: Defining a Resource Quota**

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: my-namespace
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: "8Gi"
    limits.cpu: "10"
    limits.memory: "16Gi"
```

Apply the quota:

```sh
kubectl apply -f resource-quota.yaml
```

### **Example: Setting Limits on a Pod**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: limited-pod
  namespace: my-namespace
spec:
  containers:
    - name: nginx-container
      image: nginx
      resources:
        requests:
          cpu: "500m"
          memory: "256Mi"
        limits:
          cpu: "1000m"
          memory: "512Mi"
```

## Hands-on: Define Namespaces and Apply Limits

### **Step 1: Create a Namespace**

```sh
kubectl create namespace dev-environment
```

### **Step 2: Apply a Resource Quota**

```sh
kubectl apply -f resource-quota.yaml
```

### **Step 3: Deploy a Pod with Resource Limits**

```sh
kubectl apply -f limited-pod.yaml
```

---

**[Kubernetes Resource Quotas - Advanced lab](https://github.com/elevy99927/k8s/tree/main/quota)**

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-05.md">Deployments and Rolling Updates
</A>