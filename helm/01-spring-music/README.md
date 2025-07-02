# Lab 1 – Create a ConfigMap Using Helm

**Goal:** Scaffold a fresh chart and render a simple ConfigMap.

## Steps:

1. Create chart skeleton:
   ```bash
   helm create myapp
   ```

2. Remove default templates:
   ```bash
   rm -rf myapp/templates/*
   ```

3. Add `templates/configmap.yaml`:
   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: myapp-cm
   data:
     dbname: "db-mysql"
     dbtable: "music"
   ```

4. Install and verify:
   ```bash
   helm install myapp ./myapp
   kubectl get configmap myapp-cm -o yaml
   ```

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm