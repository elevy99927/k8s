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

### **Service Discovery and DNS in Kubernetes**

Kubernetes simplifies service discovery by automatically assigning a **DNS (Domain Name System)** name to each Service within the cluster. This eliminates the need for applications to hardcode IP addresses, making the system more dynamic, scalable, and easier to manage.

#### **How It Works:**
1. **Automatic DNS Assignment:**
   - When a Service is created in Kubernetes, it is automatically assigned a unique DNS name based on its name and namespace.
   - This DNS name follows a predictable pattern, allowing applications to reliably locate and communicate with other services.

2. **DNS Name Structure:**
   - The DNS name for a Service typically follows this format:
     ```
     <service-name>.<namespace>.svc.cluster.local
     ```
     - `<service-name>`: The name of the Service.
     - `<namespace>`: The namespace where the Service is deployed (default is `default`).
     - `svc.cluster.local`: The default domain for Kubernetes Services.

3. **Example DNS Resolution:**
   - For a Service named `example-service` in the `default` namespace, the DNS name would be:
     ```
     example-service.default.svc.cluster.local
     ```
   - Applications within the cluster can use this DNS name to access the Service, instead of relying on hardcoded IP addresses.

4. **Benefits of Using DNS for Service Discovery:**
   - **Dynamic IP Handling:** Since Pods and Services in Kubernetes can have dynamic IP addresses, DNS provides a stable way to locate services without worrying about IP changes.
   - **Simplified Communication:** Applications can use human-readable DNS names instead of managing IP addresses, reducing complexity and potential errors.
   - **Namespace Isolation:** DNS names are scoped to namespaces, allowing multiple Services with the same name to exist in different namespaces without conflict.

5. **Cross-Namespace Communication:**
   - Services in one namespace can communicate with Services in another namespace by using the fully qualified domain name (FQDN). For example:
     ```
     example-service.other-namespace.svc.cluster.local
     ```

6. **Custom DNS Configuration:**
   - Kubernetes allows customization of the DNS settings (e.g., changing the default domain `cluster.local` or integrating with external DNS systems) to meet specific requirements.


### **Example Use Case:**
Imagine a microservices architecture where:
- A frontend application needs to communicate with a backend service.
- The backend service is named `backend-service` and is deployed in the `production` namespace.

Instead of hardcoding the backend's IP address, the frontend can simply use the DNS name:
```
http://backend-service.production.svc.cluster.local
```
This ensures that the frontend can always locate the backend service, even if the backend's IP address changes due to scaling or updates.


inorder check DNS resolution, run:
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