# Lab 6 – Add Ingress Template

**Goal:** Extend chart from Lab 5 with an optional Ingress.

## Steps:

1. Append Ingress block in `values.yaml`:
   ```yaml
   ingress:
     enabled: false        # toggle
     host: myapp.local
     path: /
     pathType: Prefix
   ```

2. Create `templates/ingress.yaml` (rendered only when enabled):
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: myapp
   spec:
     rules:
       - host: myapp.local
         http:
           paths:
             - path: /
               pathType: Prefix
               backend:
                 service:
                   name: myapp
                   port:
                     number: 80
   ```

3. Parameters from values.yaml:
   - Ingress name: ing-**<n>**
   - Service name: svc-**<n>**
   - Port: **<port>**

4. Install with Ingress enabled:
   ```bash
   helm upgrade --install myapp ./mychart \
     --set ingress.enabled=true \
     --set ingress.host=myapp.local
   ```

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm