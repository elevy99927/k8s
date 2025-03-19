# Kubernetes Networking

## Introduction

This document provides an overview of Kubernetes networking, including its model, communication between pods and services, and network security using policies. The exercises help in understanding how networking works in Kubernetes and how to implement isolation and security measures.

## 1. Networking Model and CNI Plugins

### Overview:
Kubernetes networking is based on a flat, cluster-wide network model where all pods can communicate with each other without NAT. This simplifies communication but requires proper network implementation to scale efficiently. Kubernetes does not include a built-in networking solution; instead, it relies on Container Network Interface (CNI) plugins to provide networking functionalities.

### Key Features of Kubernetes Networking:
- **Pod-to-Pod Communication**: Every pod receives a unique IP address, ensuring direct connectivity.
- **No NAT Between Pods**: Communication between pods occurs without network address translation.
- **Service Abstraction**: Services provide stable network endpoints, abstracting pod IP changes.
- **Extensibility with CNI Plugins**: Various plugins allow customization and network policy enforcement.

### Common CNI Plugins:
- **Calico** – Provides networking and security policy enforcement.
- **Flannel** – Simple overlay network for Kubernetes.
- **Cilium** – Uses eBPF for high-performance networking and security.
- **Weave** – Focuses on simplicity and multi-cloud support.

### CNI Plugins comparation:
<img src="./images/kubernetes_cni_comparison.png">

### Example: Deploy a Pod and Check Networking
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: network-test
  labels:
    app: test
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "sleep 3600"]
```
Check the pod’s IP:
```sh
kubectl get pods -o wide
```

### **Basic Exercise: Inspect Pod Networking**
1. Deploy the pod above.
2. Get the pod’s IP address.
3. Use `kubectl exec` to run `ping` to another pod.

### **Advanced Exercise: Deploy CNI Plugin (Flannel)**
1. Install Flannel as the CNI plugin:
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
2. Verify pod networking with `kubectl get pods -o wide`.

---

## 2. Pod-to-Pod and Pod-to-Service Communication

### Overview:
Networking in Kubernetes is designed to support microservices architectures by enabling seamless communication between application components.

- **Pod-to-Pod Communication**: All pods within a cluster can communicate directly using their assigned IP addresses. This is facilitated by the underlying CNI plugin.
- **Pod-to-Service Communication**: Kubernetes services abstract a group of pods and expose a stable IP or DNS name, ensuring reliable communication even when pods are rescheduled or replaced.

### Common Kubernetes Service Types:
- **ClusterIP** (default) – Exposes the service internally within the cluster.
- **NodePort** – Exposes the service on each node’s static port.
- **LoadBalancer** – Creates an external load balancer (cloud environments).
- **Headless Service** – Allows direct pod communication without load balancing.

### Example: Deploy a Web Server and a Client Pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-server
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

### **Basic Exercise: Connect to a Service**
1. Deploy the web server and service.
2. Deploy a busybox pod and test connectivity:
```sh
kubectl exec -it <busybox-pod> -- wget -O- http://web-service
```

### **Advanced Exercise: Use Headless Service for Direct Pod Communication**
1. Modify the service definition:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  clusterIP: None
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```
2. Run `nslookup web-service` inside another pod to discover IPs.

---

## 3. Network Policies for Isolation

### Overview:
By default, all pods in a Kubernetes cluster can communicate with each other. Network policies restrict communication based on labels and selectors, improving security by isolating workloads.

### Key Network Policy Features:
- Define ingress (incoming) and egress (outgoing) traffic rules.
- Select specific pods to which the policy applies using labels.
- Allow or deny traffic from other pods, namespaces, or external sources.

### Example: Deny All Traffic Policy
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### **Basic Exercise: Block All Ingress Traffic**
1. Apply the `deny-all` policy.
2. Deploy a pod and attempt to reach another pod (should fail).

### **Advanced Exercise: Allow Traffic Only from a Specific Pod**
1. Apply this policy to allow web traffic only from `client-pod`:
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web
spec:
  podSelector:
    matchLabels:
      app: web
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: client
    ports:
    - protocol: TCP
      port: 80
```
2. Test by deploying a `client-pod` and another pod, verifying that only `client-pod` can access the web pod.

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-09.md">Services and Endpoints</A>