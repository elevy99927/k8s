# Advanced Scheduling in Kubernetes

## 1. Node Selector

### **What is Node Selector?**

Node Selector is the simplest way to constrain a Pod to run on a specific set of nodes. It allows scheduling decisions based on **node labels**.

### **How It Works**

- Nodes are labeled with key-value pairs.
- Pods specify the label key-value pair in their `spec.nodeSelector` field.
- The scheduler places the Pod on nodes that match the specified label.

### **Example: Scheduling a Pod on a Specific Node**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  nodeSelector:
    environment: production
  containers:
    - name: nginx
      image: nginx
```

### **Applying the Label to a Node**

```sh
kubectl label nodes <node-name> environment=production
```

This ensures the Pod only runs on nodes labeled `environment=production`.

---

### **What is Taint and Toleration?**

- **Taints** prevent Pods from being scheduled on a node unless the Pod has a matching **Toleration**.
- **Tolerations** allow specific Pods to bypass taints and be scheduled on tainted nodes.

### **How It Works**

- Nodes are tainted using `kubectl taint nodes`.
- Pods must have a **matching toleration** to be scheduled on tainted nodes.

### **Example: Tainting a Node**

```sh
kubectl taint nodes node1 key=value:NoSchedule
```

This prevents any Pod from scheduling unless it has a **matching toleration**.

### **Example: Pod with a Matching Toleration**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: tolerant-pod
spec:
  tolerations:
    - key: "key"
      operator: "Equal"
      value: "value"
      effect: "NoSchedule"
  containers:
    - name: nginx
      image: nginx
```

This Pod will be scheduled on the **tainted node**.

---

## 3. Node and Pod Affinity Rules

### **What is Affinity?**

Affinity allows more complex scheduling rules than **Node Selector**.

- **Node Affinity**: Controls which nodes a Pod can be scheduled on.
- **Pod Affinity**: Ensures Pods run **together**.
- **Pod Anti-Affinity**: Ensures Pods are **separated** from each other.

### **Example: Node Affinity**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mysql
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/os
            operator: In
            values:
            - linux
  containers:
  - name: mysql-container
    image: mysql
```

This Pod will only be scheduled on **Linux nodes**.

### **Example: Pod Affinity**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-with-redis
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - redis
        topologyKey: "kubernetes.io/hostname"
  containers:
  - name: nginx
    image: nginx
```

This Pod will only schedule on nodes **where a Redis pod is running**.

### **Example: Pod Anti-Affinity**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - mysql
        topologyKey: "kubernetes.io/hostname"
  containers:
  - name: redis-container
    image: redis
```

This Pod **will not be scheduled on the same node** as a **MySQL** pod.

---

## 4. Required vs. Preferred Scheduling

**Required Scheduling** (Hard Constraint): If the condition is not met, the Pod **will not be scheduled**.

- Uses `requiredDuringSchedulingIgnoredDuringExecution`.

**Preferred Scheduling** (Soft Constraint): The scheduler tries to place the Pod based on the condition, but **it is not mandatory**.

- Uses `preferredDuringSchedulingIgnoredDuringExecution`.

### **Example: Required vs. Preferred Scheduling**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: node-role
            operator: In
            values:
            - high-performance
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1
        preference:
          matchExpressions:
          - key: region
            operator: In
            values:
            - us-west
  containers:
  - name: nginx
    image: nginx
```

- **Required Rule:** Ensures the Pod runs only on nodes labeled `node-role=high-performance`.
- **Preferred Rule:** Prefers scheduling in the **us-west** region but allows other regions if necessary.



## 5. Exercise: Pod Affinity
Follow the steps in this chapter: [Pod Affinity and Anti-Affinity Exercises](https://github.com/elevy99927/k8s/blob/main/Affinity/affinity-labs.md)

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-08.md">Services and Endpoints</A>