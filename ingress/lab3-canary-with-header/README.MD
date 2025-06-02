### 4. LAB 2: Canary Deployment Using Header

Create two versions of the `green` service. One will be treated as the canary.
<BR>Create canary deployment using HTTP headers.
<BR>1. Default image will be nginx with port 80
<BR>2. Canary image will be elevy99927/color:green

**Your task:**
<BR>Create ingress rule to route users with header `"x-canary: always"` to the Canary image
Test with header:

```sh
curl -H "x-canary: always" http://<EXTERNAL-IP>/green
```


**LAB Solution**

```yaml
# green-stable-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: green-stable
spec:
  replicas: 1
  selector:
    matchLabels:
      app: green
      version: stable
  template:
    metadata:
      labels:
        app: green
        version: stable
    spec:
      containers:
      - name: green
        image: hashicorp/http-echo
        args:
        - "-text=GREEN-STABLE"
---
apiVersion: v1
kind: Service
metadata:
  name: green
spec:
  selector:
    app: green
  ports:
  - port: 80
    targetPort: 5678
```

```yaml
# green-canary-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: green-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: green
      version: canary
  template:
    metadata:
      labels:
        app: green
        version: canary
    spec:
      containers:
      - name: green
        image: hashicorp/http-echo
        args:
        - "-text=GREEN-CANARY"
```

```yaml
# ingress-canary.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: green-ingress
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-by-header: "x-canary"
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /green
        pathType: Prefix
        backend:
          service:
            name: green
            port:
              number: 80
```

---
### **Back to Ingress session**
<A href="./Chapter-10.md">Ingress Controllers and Resources</A>

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

