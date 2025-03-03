# YAML Basics for Kubernetes

## YAML Syntax and Structure
YAML (Yet Another Markup Language) is a human-readable format used for defining Kubernetes resources. It is structured using **key-value pairs**, indentation, and lists.

### **Key YAML Features:**
- Uses **indentation** for hierarchy (spaces, not tabs).
- Represents **key-value pairs**.
- Supports **lists** and **dictionaries**.

### **Example YAML Structure:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: myapp
spec:
  containers:
    - name: my-container
      image: nginx
      ports:
        - containerPort: 80
```
- **apiVersion:** Defines the Kubernetes API version.
- **kind:** Specifies the resource type (Pod, Deployment, Service, etc.).
- **metadata:** Contains resource name and labels.
- **spec:** Defines the resource’s specifications.

---

## Writing Manifests for Kubernetes Resources
Kubernetes resources like **Pods, Deployments, and Services** are defined using YAML manifests.

### **Pod Manifest Example:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
      ports:
        - containerPort: 80
```
Apply the YAML file using:
```sh
kubectl apply -f my-pod.yaml
```

### **Deployment Manifest Example:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: nginx-container
          image: nginx
          ports:
            - containerPort: 80
```
- **replicas:** Specifies how many Pod replicas to maintain.
- **selector:** Identifies Pods managed by the Deployment.
- **template:** Defines the Pod blueprint.

### **Service Manifest Example:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: myapp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```
- **selector:** Maps the Service to Pods with matching labels.
- **ports:** Defines accessible ports.
- **type:** Determines how the Service is exposed (ClusterIP, NodePort, LoadBalancer).

Apply the manifest using:
```sh
kubectl apply -f my-service.yaml
```

---

## Hands-on: Create a Simple Canary Deployment
A **Canary Deployment** releases a new version of an application to a subset of users before rolling it out fully.

### **Canary Deployment YAML:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: canary-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
        version: canary
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
          ports:
            - containerPort: 80
```
Apply the Canary Deployment:
```sh
kubectl apply -f canary-deployment.yaml
```


---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-004.md">Namespaces and Resource Management </A>