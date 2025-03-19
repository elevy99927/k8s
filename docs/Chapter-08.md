# Kubernetes Networking

## 1. Networking Model and CNI Plugins

### Overview:
Kubernetes networking is based on a flat, cluster-wide network model where all pods can communicate with each other without NAT. Container Network Interface (CNI) plugins provide different networking implementations to handle traffic between pods, services, and external systems.

### Common CNI Plugins:
- **Calico** – Network security and policy enforcement.
- **Flannel** – Simple overlay network for Kubernetes.
- **Cilium** – Provides eBPF-based security and observability.

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
- **Pod-to-Pod**: Direct communication between pods using cluster IPs.
- **Pod-to-Service**: Uses Kubernetes services to provide stable communication endpoints.

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
By default, all pods in a Kubernetes cluster can communicate with each other. Network policies restrict communication based on labels and selectors.

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