## Ingress and NGINX Controller

### 1. Background

Ingress in Kubernetes allows HTTP and HTTPS routing to services within the cluster based on hostname or URI path. Instead of exposing multiple services via `NodePort` or `LoadBalancer`, Ingress offers a more efficient solution with a single external IP and routing rules.

To use Ingress, an Ingress Controller must be deployed. A popular one is **NGINX Ingress Controller**, which watches for Ingress resources and configures NGINX accordingly.

#### 1.1 Comparison with Other Ingress Controllers

There are several widely used Ingress controllers beyond NGINX:

| Ingress Controller           | Description                                                                             | Link                                                                                    |
| ---------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| **NGINX Ingress Controller** | Most commonly used, flexible, supports custom annotations and rich rule sets            | [GitHub](https://github.com/kubernetes/ingress-nginx)                                   |
| **HAProxy Ingress**          | High performance, native HAProxy integration, great for L7 routing                      | [GitHub](https://github.com/jcmoraisjr/haproxy-ingress)                                 |
| **Traefik**                  | Dynamic, lightweight, supports automatic certificate management (Let's Encrypt)         | [GitHub](https://github.com/traefik/traefik)                                            |
| **Contour**                  | Built on Envoy, supports HTTP/2, gRPC, and modern protocols natively                    | [GitHub](https://github.com/projectcontour/contour)                                     |
| **Istio Ingress Gateway**    | Part of a full service mesh, integrates traffic control with security and observability | [Istio](https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/) |

> 📌 Recommendation: Use NGINX for general-purpose ingress in most clusters unless a specific need (e.g., service mesh) justifies an alternative.

---

### 2. Install NGINX Ingress Controller

Apply the all-in-one manifest to install NGINX Ingress:

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.1/deploy/static/provider/cloud/deploy.yaml
```

Wait until the controller pod and service are up:

```sh
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
```

Use the `EXTERNAL-IP` of the `ingress-nginx-controller` service to access your routes.

---

### 3. LAB 1: Create Ingress with URI Path Routing

Create two services: `red` and `yellow`, and route traffic using Ingress:

```yaml
# red-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: red
spec:
  replicas: 1
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
        image: hashicorp/http-echo
        args:
        - "-text=RED"
---
apiVersion: v1
kind: Service
metadata:
  name: red
spec:
  selector:
    app: red
  ports:
  - port: 80
    targetPort: 5678
```

```yaml
# yellow-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: yellow
spec:
  replicas: 1
  selector:
    matchLabels:
      app: yellow
  template:
    metadata:
      labels:
        app: yellow
    spec:
      containers:
      - name: yellow
        image: hashicorp/http-echo
        args:
        - "-text=YELLOW"
---
apiVersion: v1
kind: Service
metadata:
  name: yellow
spec:
  selector:
    app: yellow
  ports:
  - port: 80
    targetPort: 5678
```

```yaml
# ingress-red-yellow.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: color-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /red
        pathType: Prefix
        backend:
          service:
            name: red
            port:
              number: 80
      - path: /yellow
        pathType: Prefix
        backend:
          service:
            name: yellow
            port:
              number: 80
```

Access via:

```
curl http://<EXTERNAL-IP>/red
curl http://<EXTERNAL-IP>/yellow
```

---

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
<a href="https://github.com/elevy99927/k8s/tree/main/ingress/lab3-canary-with-header">Canary Deployment Using Header Solution</A>


---

### 5. Advanced Lab - Secure Ingress with TLS**

Objective: Use a self-signed certificate to encrypt traffic.

Steps:

1. Generate TLS cert and key:

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -out tls.crt -keyout tls.key -subj "/CN=example.com/O=example"
```

2. Create secret with your tls key:

```sh
kubectl create secret tls tls-secret --key tls.key --cert tls.crt
```

3. Add `tls` block to ingress:

```yaml
spec:
  tls:
  - hosts:
    - example.com
    secretName: tls-secret
```

4. Add `/etc/hosts` entry pointing `example.com` to the Ingress IP
5. Use `curl -k https://example.com/...`

This lab adds security and prepares learners for real-world deployments.

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-11.md">Managing Applications with Helm</A>