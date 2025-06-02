# Using ConfigMaps in Kubernetes

### Background

In Kubernetes, a **ConfigMap** is an object that lets you inject configuration data into your applications without hardcoding values into container images. This promotes portability, flexibility, and environment-specific behavior.

ConfigMaps are commonly used to:

* Store application configuration files
* Define environment variables for containers
* Inject runtime parameters into applications

They support both key-value pairs and file-based configuration, and can be consumed by Pods as environment variables or as mounted files.

---

### Objective

Demonstrate how to create and use a ConfigMap in a Pod, both as environment variables and as mounted configuration files.

---

### Prerequisites

* A running Kubernetes cluster
* `kubectl` configured to access the cluster

---

## LAB 1 Using ConfigMap for Environment

###

### Step 1: Create the ConfigMap (from literals)

```bash
kubectl create configmap app-config --from-literal=APP_MODE=production --from-literal=APP_DEBUG=false
```

### Step 2: Use the ConfigMap in a Pod

#### A. As Environment Variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-env-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["sh", "-c", "env | grep APP"]
    envFrom:
    - configMapRef:
        name: app-config
  restartPolicy: Never
```

### Step 3: Apply and Test

```
kubectl apply -f configmap-env-pod.yaml
kubectl logs configmap-env-demo
```

### Step 4: Update the ConfigMap (Optional)

To update a key:

```
kubectl create configmap app-config --from-literal=APP_MODE=debug -o yaml --dry-run=client | kubectl apply -f -
```

Restart the Pod to load the updated values:

```
kubectl delete pod <pod-name>
```

---

## LAB 2 Using ConfigMap as file

### Step 1: Create a ConfigMap

Create a file named `app.properties`:

```properties
APP_MODE=production
APP_DEBUG=false
```

Then create the ConfigMap:

```bash
kubectl create configmap app-config --from-file=app.properties
```

---

### Step 2: Use the ConfigMap in a Pod

#### B. As Mounted Files

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-volume-demo
spec:
  containers:
  - name: busybox
    image: busybox
    command: ["cat", "/etc/config/app.properties"]
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
  restartPolicy: Never
```

---

### Step 3: Apply and Test

```
kubectl apply -f configmap-volume-pod.yaml
kubectl logs configmap-volume-demo
```

### Validation

* Verify the environment variables are available inside the container using `env` or `printenv`.
* Verify mounted files contain the correct content using `cat /etc/config/*` inside the container.

## LAB 3 Mount HTML to NGINX Using ConfigMap

### Step 1: Create `index.html`

Create a file named `index.html` with the following content:

```html
<html>
<head>
    <title>A new Index.html</title>
</head>
<body bgcolor="#c0c0c0">
    <br> <b>Hello Nginx</b>
    <br> This is a new index.html
</body>
</html>
```

### Step 2: Create the ConfigMap from the File

```bash
kubectl create configmap index-html --from-file=index.html
```

### Step 3: Create the NGINX Deployment and Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: index-html-config
          mountPath: "/usr/share/nginx/html"
          readOnly: true
      volumes:
      - name: index-html-config
        configMap:
          name: index-html
---
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```

### Step 4: Apply the Configuration

```bash
kubectl apply -f index.html
kubectl apply -f nginx-deployment.yaml
```

### Step 5: Test the Deployment

Get the NodePort service IP and test with curl:

```bash
kubectl get svc my-service
```

Then run:

```bash
curl http://<YOUR_NODE_IP>:<NODE_PORT>
```

You should see the content of your custom `index.html` rendered in the response.

---
- **Main page**: [https://github.com/elevy99927/k8s/](Kubernetes Tutorial)
