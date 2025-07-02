# Lab 5 – Deployment & Service Templates

**Goal:** Add application Deployment and Service templates.

## Steps:

1. Create `templates/deployment.yaml` and `templates/service.yaml`.

2. Parameterize via `values.yaml`:
   ```yaml
   replicaCount: 2
   image:
     repository: nginx
     tag: stable
   service:
     type: ClusterIP
     port: 80
   ```

3. Install and test access to Service IP.

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm