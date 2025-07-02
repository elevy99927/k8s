# Lab 3 – Dynamic ConfigMap with `values.yaml`

**Goal:** Source data from `values.yaml` and allow overrides at install time.

## Steps:

1. Add to `values.yaml`:
   ```yaml
   dbname: "db-mysql"
   dbtable: "music"
   image: "nginx"
   tag: "1.25"
   ```

2. Update `configmap.yaml`:
   ```yaml
   data:
     dbname: {{ .Values.dbname }}
     dbtable: {{ .Values.dbtable }}
     image: {{ .Values.image }}:{{ .Values.tag }}
   ```

3. Install & override example:
   ```bash
   helm install dev ./myapp --set dbname=customdb
   ```

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm