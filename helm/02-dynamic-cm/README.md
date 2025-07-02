# Lab 2 – Reuse ConfigMap with Built‑in Objects

**Goal:** Introduce Helm built‑in objects to make templates reusable.

## Steps:

1. Keep chart from Lab 1 (or repeat steps 1–2).

2. Update `configmap.yaml` to use built‑ins:
   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: {{ .Release.Name }}-cm
   data:
     dbname: "db-mysql"
     dbtable: "music"
     kubeVersion: {{ .Capabilities.KubeVersion | quote }}
   ```

3. Install and verify multiple releases:
   ```bash
   helm install score ./myapp
   helm install replay ./myapp
   kubectl get configmap
   ```

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm