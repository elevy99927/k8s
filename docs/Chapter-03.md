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

## Hands-on: Creating a Pod Using YAML Manifest

In this section, we will create a Kubernetes Pod using a YAML manifest and deploy it to the cluster.

### **Step 1: Define the Pod Manifest**

Create a file called `my-pod.yaml` with the following contents:

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
[my-pod.yaml](https://raw.githubusercontent.com/elevy99927/k8s/refs/heads/main/pod/my-pod.yaml)

### **Step 2: Apply the Manifest**

Use the following command to deploy the Pod:

```sh
kubectl apply -f my-pod.yaml
```

### **Step 3: Verify the Pod Status**

Check if the Pod is running:

```sh
kubectl get pods
```

To describe the Pod and see more details:

```sh
kubectl describe pod my-pod
```

### **Step 4: Access the Pod Logs**

You can check logs for the running container using:

```sh
kubectl logs my-pod
```

### **Step 5: Delete the Pod**

If you no longer need the Pod, delete it using:

```sh
kubectl delete pod my-pod
```

---

Next, we will explore **Namespaces and Resource Management** to efficiently organize workloads in Kubernetes.

## Deployment YAML: Converting a Pod to a Deployment

A **Deployment** in Kubernetes ensures that a set of Pods are running and managed efficiently. Deployments allow you to easily scale, update, and manage your application.

### **Converting a Pod YAML to a Deployment YAML**

A simple Pod manifest:

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

To convert it into a Deployment, wrap it inside a **Deployment spec**:

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
[my-deployment.yaml](https://raw.githubusercontent.com/elevy99927/k8s/refs/heads/main/deploymet/strategy/deploymet.yaml)
- ***replicas:*** Specifies how many Pods should run.
- ***selector:*** Matches the Pods controlled by this Deployment.
- ***template:*** Defines the Pod configuration.

*Apply the Deployment:*

```sh
kubectl apply -f my-deployment.yaml
```

### **Verifying Deployment and ReplicaSet Status**

Once the Deployment is applied, you can check the status of the Deployment, ReplicaSets, and Pods using the following commands:

#### **Check Deployment Details**
```sh
kubectl get deploy
kubectl describe deploy my-deployment
```

#### **Check ReplicaSet Created by the Deployment**
```sh
kubectl get rs
kubectl describe rs
```

#### **Check the Pods Managed by the Deployment**
```sh
kubectl get pods
kubectl describe pod <pod-name>
```

These commands will help you understand how Deployments manage ReplicaSets, and how ReplicaSets ensure the right number of Pods are running.

---

## Labels and Their Usage

**Labels** are key-value pairs attached to Kubernetes objects. They help in organizing, selecting, and filtering resources.

### **Example of Labels in a Deployment**

```yaml
metadata:
  labels:
    app: myapp
    environment: production
```

Labels are used in **Selectors** to filter objects:

```yaml
selector:
  matchLabels:
    app: myapp
```

You can list Pods with a specific label:

```sh
kubectl get pods -l app=myapp
```

---

## Service YAML: Exposing Applications

A **Service** enables communication between different components inside a Kubernetes cluster.

### **Service Manifest Example**

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

- **Kind** Service
- **selector:** Targets Pods with matching labels.
- **ports:** Defines which ports are exposed.
- **type:** Defines how the Service is accessed (ClusterIP, NodePort, LoadBalancer).

Apply the Service:

```sh
kubectl apply -f my-service.yaml
```

---

## Hands-on: Create a Simple Gree/Blue Deployment

A **Green/Blue Deployment** releases a new version of an application to a subset of users before rolling it out fully.

### 1. **create deployment blue.**
- **image**: supergiantkir/animals:bear
- **replicas**: 2

### 2. **create deployment green**
- **image**: supergiantkir/animals:moose
- **replicas**: 1

### 3. **expose the deployments using a service**
- **type**: LoadBalancer
- **port**: 80:80
- **Use Labels**

Test your solution:
```bash
for i in {1..100} ; do curl http://<YOUR_IP>/ |grep img ; done |sort |uniq -c
```

Solution:
[Blue-Green](https://github.com/elevy99927/k8s/tree/main/blue-green)

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-04.md">Namespaces and Resource Management </A>