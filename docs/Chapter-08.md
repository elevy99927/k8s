# Chapter 8: Services and Endpoints

## Introduction

Kubernetes **Services and Endpoints** allow applications to communicate within a cluster efficiently. While Pods are ephemeral and can be replaced dynamically, Services provide stable networking for accessing applications, ensuring consistency even when pods are rescheduled.

---

## 1. ClusterIP, NodePort, LoadBalancer

### Overview:

Kubernetes Services abstract a set of Pods and provide a consistent method for accessing them. There are different types of services:

- **ClusterIP** (default) – Provides internal access to a service within the cluster.
- **NodePort** – Exposes the service on each Node's IP at a specific port.
- **LoadBalancer** – Creates an external load balancer (available in cloud environments).

### Service Discovery and DNS
Kubernetes automatically assigns a DNS name to each Service within the cluster. Applications can access other services using DNS instead of hardcoding IP addresses.

Example DNS name resolution for a service:
```
http://example-service.default.svc.cluster.local
```

To check DNS resolution, run:
```sh
kubectl exec -it <pod-name> -- nslookup example-service
```

### Connecting a Deployment to a Service Using Labels
Services rely on **labels and selectors** to identify which pods they should route traffic to. This allows dynamic updates without modifying the service configuration.

#### Example: Deployment and Matching Service
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp-container
        image: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp  # Matches the label on the Deployment
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
```

### **Basic Exercise: Expose a Pod Using Different Service Types**
Using the YAML from the previous example, complete the following tasks:

1. Deploy a Pod with a web server.
2. Create a ClusterIP service and test connectivity within the cluster.
3. Change the service type to LoadBalancer and test external access.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: example-service
spec:
  selector:
    app: myapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: ClusterIP  # Change to NodePort or LoadBalancer as needed
```

### Discussion:
- Can you apply the new YAML and change the Service type?
- Can you edit the service and change the service type?
- Why does this happen?

## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-09.md">Kubernetes Networking</A>