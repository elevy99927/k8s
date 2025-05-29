## Lab: Canary Deployment with NGINX Ingress

### Objective

Deploy two versions of a service (`red` and `red-canary`) and use NGINX Ingress to split incoming traffic:

* 80% to the stable version (`red`)
* 20% to the canary version (`red-canary`)

---

### Prerequisites

* A Kubernetes cluster with NGINX Ingress Controller installed.
* `kubectl` configured and pointing to your cluster.
* Basic knowledge of Deployments and Services in Kubernetes.

---

### Step 1: Deploy Stable and Canary Versions

#### `red-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: red
spec:
  replicas: 2
  selector:
    matchLabels:
      app: red
  template:
    metadata:
      labels:
        app: red
    spec:
      containers:
      - name: red
        image: elevy99927/colors:red
        ports:
        - containerPort: 80
```

#### `red-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: red
spec:
  selector:
    app: red
  ports:
  - port: 80
    targetPort: 80
```

#### `red-canary-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: red-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: red-canary
  template:
    metadata:
      labels:
        app: red-canary
    spec:
      containers:
      - name: red-canary
        image: elevy99927/colors:green
        ports:
        - containerPort: 80
```

#### `red-canary-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: red-canary
spec:
  selector:
    app: red-canary
  ports:
  - port: 80
    targetPort: 80
```

---

### 🌐 Step 2: Create Ingress Resources

#### `ingress-stable.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: color-ingress-stable
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: red
            port:
              number: 80
```

#### `ingress-canary.yaml`

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: color-ingress-canary
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "20"
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: red-canary
            port:
              number: 80
```

---

### Step 3: Apply All Resources

```bash
kubectl apply -f red-deployment.yaml
kubectl apply -f red-service.yaml
kubectl apply -f red-canary-deployment.yaml
kubectl apply -f red-canary-service.yaml
kubectl apply -f ingress-stable.yaml
kubectl apply -f ingress-canary.yaml
```

---

### Step 4: Test Traffic Distribution

Run the following command multiple times to simulate requests:

```bash
for i in {1..100}; do curl -s http://<INGRESS_IP>/ ; done | sort | uniq -c
```

Expected output:

* Around 80 responses from `red`
* Around 20 responses from `red-canary`

> Replace `<INGRESS_IP>` with your actual ingress controller external IP.

---

### Validation

You can visually verify the split by looking at logs or adding distinguishing responses in the container’s output (e.g., different image, HTML, or message).


---
### **Next Steps**
<A href="./Chapter-10.md">Back to Ingress Controllers and Resources</A>

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)
