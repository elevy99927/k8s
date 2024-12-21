# Affinity Examples and Labs

Kubernetes Affinity rules tutorials and examples are contained in this directory.
These rules allow you to influence or control the placement of the pods sitting on top of the nodes and/or the characteristics of the pods.

## What is Affinity?

In simple terms, Affinity in Kubernetes is rule sets that assist in making decisions regarding the placement of the pods.
<BR>It includes two main types:

1. **Node Affinity**: Helps to define on which nodes a pod should or should not be run considering the node labels.
2. **Pod Affinity and Anti-Affinity**: Help to define the proximity of a pod to other assigned to different pods based on specific pod labels.

### When to Use Affinity

- To ensure workloads are placed on specific nodes for performance, security, or compliance.
- To co-locate pods that communicate frequently, reducing latency.
- To isolate workloads for stability or resource allocation.

### When Not to Use Affinity

- If the cluster resources are constrained, as strict affinity rules might prevent pods from being scheduled.
- When scheduling flexibility is more critical than placement control.
- Overusing anti-affinity can cause fragmentation, reducing cluster efficiency.

## Examples

### Example 1: Node Affinity

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: node-affinity-example
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: environment
                operator: In
                values:
                  - production
  containers:
    - name: nginx
      image: nginx
```

- **Purpose**: Ensures that the pod runs only on nodes labeled with `environment=production`.

### Example 2: Pod Anti-Affinity

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-anti-affinity-example
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        labelSelector:
          matchLabels:
            app: backend
        topologyKey: "kubernetes.io/hostname"
  containers:
    - name: nginx
      image: nginx
```

- **Purpose**: Prevents the pod from being scheduled on the same node as other pods with the label `app=backend`.

## Labs

### Lab 1: Node Affinity (`01`)

- **Objective**: Schedule pods only on nodes with a specific label.
- **Steps**:
  1. Label a node with `key=value`, e.g., `environment=production`.
  2. Apply a manifest with a required node affinity rule.
  3. Verify pod placement using `kubectl get pods -o wide`.

### Lab 2: Pod Affinity (`02`)

- **Objective**: Co-locate pods with similar labels.
- **Steps**:
  1. Deploy pods with a specific label, e.g., `app=frontend`.
  2. Apply a pod manifest with an affinity rule targeting the label.
  3. Confirm the pods are scheduled on the same node.

### Lab 3: Pod Anti-Affinity (`03`)

- **Objective**: Ensure pods with conflicting roles are not scheduled on the same node.
- **Steps**:
  1. Deploy pods with a label, e.g., `app=backend`.
  2. Apply a pod manifest with an anti-affinity rule targeting the label.
  3. Verify that the pods are placed on separate nodes.

---

## Open in Google Cloud Shell

You can directly open this repository in Google Cloud Shell to start exploring the examples:

[![Open in Google Cloud Shell](https://camo.githubusercontent.com/198b1d237c4023111c3f163552130daf552a0a684ea7a8ed1adc98c9b7f59659/68747470733a2f2f677374617469632e636f6d2f636c6f75647373682f696d616765732f6f70656e2d62746e2e737667)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/elevy99927/k8s)

---
## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

## Contact

For questions or feedback, feel free to reach out:

- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

