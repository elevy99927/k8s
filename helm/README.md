# Helm Tutorial for Kubernetes

---

## 1. What is a Package Manager?

A **package manager** is a tool that automates installing, upgrading, configuring, and removing software applications. In traditional software, package managers like `apt` (Ubuntu), `yum` (RHEL), or `npm` (Node.js) simplify managing software dependencies and updates.

**In Kubernetes:** A package manager helps you manage complex Kubernetes applications by grouping multiple resource manifests and templates together, making installation and upgrades easy and repeatable.

---

## 2. Why Helm?

**Helm** is the de‑facto package manager for Kubernetes. It solves several challenges in Kubernetes deployments:

* **Template Reuse:** Parameterize YAML with variables.
* **Consistency:** Avoid manual YAML editing for each environment.
* **Versioning:** Upgrade, rollback, and manage releases.
* **Complex Deployments:** Package multiple resources (Deployment, Service, Ingress, etc.) together.
* **Community Ecosystem:** Reuse existing charts from others.

**Example Use Cases:**

* Deploying Nginx, databases, monitoring tools (Prometheus, Grafana), or in‑house apps.
* Managing different configs (dev, staging, prod) with a single source.

---

## 3. Helm Alternatives

* **Kustomize:** Built‑in to `kubectl` — focuses on patching YAMLs for different environments.
* **Kapp (Carvel):** Simple app lifecycle and dependency management.
* **Operator Frameworks (Operator SDK, OLM):** For advanced, domain‑specific controllers.
* **DIY Scripting (kubectl + Bash/Python):** Works, but lacks templating and release management.

---

## 4. [ArtifactHub.io](https://artifacthub.io/)

Central public repository for Helm charts and other Kubernetes artifacts.

---

## 5. Helm Concepts

### Chart Structure

```
myapp/
├── Chart.yaml       # Metadata (name, version, description)
├── values.yaml      # Default config values
└── templates/       # Parameterized Kubernetes manifests
```

### Values & Overrides

* `values.yaml` – defaults
* Override with extra files (`-f values-dev.yaml`) or `--set key=value`

### Chart Lifecycle

1. **Install**  `helm install myapp ./myapp`
2. **Upgrade**  `helm upgrade myapp ./myapp --set image.tag=2.0.0`
3. **Rollback** `helm rollback myapp 1`
4. **Uninstall** `helm uninstall myapp`

### Best Practices

* Keep templates DRY using `_helpers.tpl`.
* Document all values in `values.yaml`.
* Pin chart versions in production.

---

## 6. Helm Installation

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

Basic CLI:

```bash
helm version
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

---

## 7. Working with Helm — Hands‑On Labs

Below is the lab sequence exactly as presented in **Helm Part 1**.

### Lab 1 – Create a ConfigMap Using Helm

**Goal:** Scaffold a fresh chart and render a simple ConfigMap.

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

### Lab 2 – Reuse ConfigMap with Built‑in Objects

**Goal:** Introduce Helm built‑in objects to make templates reusable.

1. Keep chart from Lab 1 (or repeat steps 1–2).
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

### Lab 3 – Dynamic ConfigMap with `values.yaml`

**Goal:** Source data from `values.yaml` and allow overrides at install time.

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

### Lab 4 – Using Helm Functions in Templates

**Goal:** Apply Sprig helper functions for string manipulation.
*Transform requirements from the slides:*

* `dbname` → uppercase + quote
* `eat`   → uppercase, truncate to 13 chars, quote
* `drink` → uppercase

`values.yaml` sample:

```yaml
dbname: musicdb
eat: spaghetti_al_pesto
drink: coffee
```

`configmap.yaml` snippet:

```yaml
data:
  dbname: {{ quote (upper .Values.dbname) }}
  eat:    {{ quote (trunc 13 (upper .Values.eat)) }}
  drink:  {{ quote (upper .Values.drink) }}
```

Solution repo: [https://github.com/elevy99927/k8s/tree/main/helm/04-functions](https://github.com/elevy99927/k8s/tree/main/helm/04-functions)

---

### Lab 5 – Deployment & Service Templates

**Goal:** Add application Deployment and Service templates.

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
   Solution repo: [https://github.com/elevy99927/k8s/tree/main/helm/05-deployment](https://github.com/elevy99927/k8s/tree/main/helm/05-deployment)

---

### Lab 6 – Add Ingress Template (pre‑work for Ingress Labs)

**Goal:** Extend chart from Lab 5 with an optional Ingress.

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

3. The following parameters will come from values.yaml

   Ingress name: ing-**\<name>**

   Service name: svc-**\<name>**

   Port: **\<port>**

4. Install with Ingress enabled:

   ```bash
   helm upgrade --install myapp ./mychart \
     --set ingress.enabled=true \
     --set ingress.host=myapp.local
   ```

Solution repo: [https://github.com/elevy99927/k8s/tree/main/helm/06-deploy-ingress](https://github.com/elevy99927/k8s/tree/main/helm/06-deploy-ingress)

---

## References

* [Helm Documentation](https://helm.sh/docs/)
* [ArtifactHub](https://artifacthub.io/)
* [Bitnami Helm Charts](https://bitnami.com/stacks/helm)

---

## Contact

* **Email:** [eyal@levys.co.il](mailto:eyal@levys.co.il)
* **GitHub:** [https://github.com/elevy99927](https://github.com/elevy99927)
