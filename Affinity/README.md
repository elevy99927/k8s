# Affinity Examples and Labs

This directory contains examples and labs that demonstrate the use of Kubernetes Affinity rules. These rules allow you to influence or control pod placement based on node or pod characteristics.

## Compatibility with Kubernetes 1.30

After analyzing the content, no known issues or APIs are identified as incompatible with Kubernetes version 1.30. All examples and labs should work as expected.

## What is Affinity?

Affinity in Kubernetes is a set of rules used to influence pod scheduling decisions. It includes two main types:

1. **Node Affinity**: Determines which nodes a pod should or should not run on based on node labels.
2. **Pod Affinity and Anti-Affinity**: Determines pod co-location (or separation) based on labels assigned to other pods.

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

- **Objective**: Schedule pods only on nodes with a specific label (e.g., `os=linux`).
- **Steps**:
  1. Label a node with `os=linux`:
     ```bash
     kubectl label nodes <node-name> os=linux
     ```
  2. Apply the following manifest:
     ```yaml
     apiVersion: v1
     kind: Pod
     metadata:
       name: node-affinity-linux
     spec:
       affinity:
         nodeAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             nodeSelectorTerms:
               - matchExpressions:
                   - key: os
                     operator: In
                     values:
                       - linux
       containers:
         - name: nginx
           image: nginx
     ```
  3. Verify pod placement using `kubectl get pods -o wide`.

### Lab 2: Pod Affinity and Anti-Affinity (`02`)

- **Objective**: Ensure a web app runs with Redis, while Redis cannot coexist with MySQL.
- **Steps**:
  1. Apply the following manifests:
     - **Redis**:
       ```yaml
       apiVersion: v1
       kind: Pod
       metadata:
         name: redis
         labels:
           app: redis
       spec:
         containers:
           - name: redis
             image: redis
       ```
     - **MySQL**:
       ```yaml
       apiVersion: v1
       kind: Pod
       metadata:
         name: mysql
         labels:
           app: mysql
       spec:
         containers:
           - name: mysql
             image: mysql
       ```
     - **Web**:
       ```yaml
       apiVersion: v1
       kind: Pod
       metadata:
         name: web
         labels:
           app: web
       spec:
         affinity:
           podAffinity:
             requiredDuringSchedulingIgnoredDuringExecution:
               - labelSelector:
                   matchLabels:
                     app: redis
                 topologyKey: "kubernetes.io/hostname"
           podAntiAffinity:
             requiredDuringSchedulingIgnoredDuringExecution:
               - labelSelector:
                   matchLabels:
                     app: mysql
                 topologyKey: "kubernetes.io/hostname"
         containers:
           - name: nginx
             image: nginx
       ```
  2. Verify pod placement with `kubectl get pods -o wide`.

### Lab 3: Combined Affinity (`03`)

- **Objective**: Create a combined example that integrates Node Affinity, Pod Affinity, and Pod Anti-Affinity.
- **Steps**:
  1. Apply the following manifest:
     ```yaml
     apiVersion: v1
     kind: Pod
     metadata:
       name: combined-pod
       labels:
         app: all-in-one
     spec:
       affinity:
         nodeAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             nodeSelectorTerms:
               - matchExpressions:
                   - key: os
                     operator: In
                     values:
                       - linux
         podAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             - labelSelector:
                 matchLabels:
                   app: redis
               topologyKey: "kubernetes.io/hostname"
         podAntiAffinity:
           requiredDuringSchedulingIgnoredDuringExecution:
             - labelSelector:
                 matchLabels:
                   app: mysql
               topologyKey: "kubernetes.io/hostname"
       containers:
         - name: nginx
           image: nginx
     ```
  2. Verify placement using `kubectl get pods -o wide`.

## Open in Google Cloud Shell

You can directly open this repository in Google Cloud Shell to start exploring the examples:

[![Open in Google Cloud Shell](https://camo.githubusercontent.com/198b1d237c4023111c3f163552130daf552a0a684ea7a8ed1adc98c9b7f59659/68747470733a2f2f677374617469632e636f6d2f636c6f75647373682f696d616765732f6f70656e2d62746e2e737667)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/elevy99927/k8s)

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

For questions or feedback, feel free to reach out:

- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

