# Using ConfigMaps in Kubernetes

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
- **Main page**: [https://github.com/elevy99927/k8s/configmap](Kubernetes Tutorial)
