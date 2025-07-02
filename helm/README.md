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


### Lab 8 – Reusable Helpers (`_helpers.tpl`)

**Goal:** Learn how to place common logic in **named templates** inside `_helpers.tpl` so every manifest can call the same helper instead of duplicating code.

#### 8.1 Why helpers?

* Keep templates **DRY** – branding, naming, or label logic lives in one place.
* Enforce consistency: a single function defines how resources are named or annotated.
* Easier maintenance: update the helper once, all templates inherit the change.

#### 8.2 Example helper snippet

Below is a minimal helper that returns a fully‑qualified name and standard labels.  Add this to `_helpers.tpl` and then reference it from multiple manifests.

```tpl
{{- define "mychart.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mychart.labels" -}}
app.kubernetes.io/name: {{ include "mychart.fullname" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
```

Usage in a Deployment manifest:

```yaml
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
{{ include "mychart.labels" . | indent 4 }}
```

#### 8.3 Task (no solution here)

Create a `_helpers.tpl` file that provides at least two named templates:

1. **`{{ include "mychart.fullname" . }}`** → returns a stable release‑aware name.
2. **`{{ include "mychart.labels" . }}`** → returns a map of standard labels.

Update your Deployment, Service, and Ingress templates to use these helpers instead of hard‑coding names and labels.

Repository link for reference solution ➜ [https://github.com/elevy99927/k8s/tree/main/helm/08-helpers](https://github.com/elevy99927/k8s/tree/main/helm/08-helpers)

#### 8.3 Advanced helper usage example

Below is an illustrative helper that appends a region suffix **or** the Kubernetes major.minor version.

```tpl
{{/* Append region or kube version suffix */}}
{{- define "mychart.envSuffix" -}}
{{- if .Values.region }}
{{ printf "-%s" (.Values.region | lower) }}
{{- else if .Capabilities.KubeVersion.GitVersion }}
{{ printf "-k%s" (.Capabilities.KubeVersion.Minor | trimPrefix "v") }}
{{- else }}
{{ "" }}
{{- end -}}
{{- end }}
```

Usage in a Deployment name:

```yaml
metadata:
  name: {{ include "mychart.fullname" . }}{{ include "mychart.envSuffix" . }}
```
---
# Helm Tutorial – Lab 9: Hooks

---

## 9.1 What Are Hooks?

Helm **hooks** are special Kubernetes resources that run at predefined points in a release lifecycle (e.g., *pre‑install*, *post‑install*, *pre‑upgrade*, *post‑delete*, and *test*). They allow you to:

* Perform initialization logic **before** a chart is installed or upgraded.
* Validate cluster state **after** installation through test jobs.
* Run clean‑up logic when a release is deleted or rolled back.

Hooks give chart authors a way to orchestrate jobs or tasks **outside** the main release objects without polluting the standard resource set.

---

## 9.2 Reference Documentation

For the full list of lifecycle points, annotations, and policies, see:
[https://helm.sh/docs/topics/charts\_hooks/](https://helm.sh/docs/topics/charts_hooks/)

---

## 9.3 Key Hook Annotations Explained

```yaml
annotations:
  # Marks this resource as a hook. Otherwise it becomes a normal release object.
  "helm.sh/hook": pre-install,pre-upgrade,test

  # Lower numbers run earlier; higher numbers run later when multiple hooks have the same phase.
  "helm.sh/hook-weight": "1"

  # Automatically delete hook resources when the hook succeeds (keeps the cluster clean).
  "helm.sh/hook-delete-policy": hook-succeeded
```

| Annotation                       | Purpose                                                                                                                                                                          |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **`helm.sh/hook`**               | Comma‑separated list of lifecycle points when the resource should run. In this example the Job will run **before installation**, **before upgrade**, and **during chart tests**. |
| **`helm.sh/hook-weight`**        | Controls execution order *within the same lifecycle point*. Lower weight runs first.                                                                                             |
| **`helm.sh/hook-delete-policy`** | Dictates when Helm should delete the hook resource. `hook‑succeeded` cleans up only once the Job completes successfully.                                                         |

---

## 9.4 Scenario – `post-install-job.yaml` with Hooks

Imagine you need to **seed a database** or **run a smoke test** every time your application is installed or upgraded. You can package that logic in a *Job* and wire it to Helm’s lifecycle hooks.

1. **Chart structure** (simplified):

   ```text
   mychart/
   ├── templates/
   │   ├── deployment.yaml
   │   ├── service.yaml
   │   └── post-install-job.yaml   <-- hook Job
   └── values.yaml
   ```
2. **Hook execution flow**

   * *pre‑install*: Job runs **before** Helm creates the Deployment/Service, verifying prerequisites.
   * *pre‑upgrade*: Same Job runs **before** upgrading an existing release, preventing bad migrations.
   * *test*: When you call `helm test <release>`, the Job executes again as an integration test.
3. **Automatic clean‑up** thanks to `hook‑succeeded` keeps the cluster tidy.
4. **Fail‑fast behaviour** – If the Job fails (non‑zero exit code), the entire install/upgrade fails, protecting production.

### **Solution**

A working example can be found in the repo under: [https://github.com/elevy99927/k8s/tree/main/helm/09-hooks](https://github.com/elevy99927/k8s/tree/main/helm/09-hooks)

Use this as a reference for crafting your own hook‑based workflows.

---
Lab 10 – NOTES.txt and .Capabilities

Goal: Demonstrate how to deliver dynamic post‑install guidance using Helm’s NOTES.txt template and the .Capabilities object.

10.1 What is NOTES.txt?

NOTES.txt is a special Helm template rendered after an install or upgrade. Its output is printed to the user’s console.

It lets chart authors surface endpoints, credentials, or follow‑up commands without cluttering Kubernetes manifests.

Being a template, it supports {{ ... }} logic, functions, and access to chart values.

10.2 Why use NOTES.txt?

Onboarding: Give immediate next‑steps (e.g., kubectl port‑forward, browser URLs).

Contextual info: Show different instructions depending on service type, ingress enablement, or cluster version.

Automation hints: CI pipelines can parse the output for dynamic environment details.

10.3 Mini Example

CHART NAME: {{ .Chart.Name }}
RELEASE NAME: {{ .Release.Name }}

{{- if .Values.ingress.enabled }}
Your application is exposed via Ingress → http://{{ .Values.ingress.host }}/
{{- else }}
Service Type: {{ .Values.service_type }}
Run: kubectl port-forward svc/{{ include "mychart.fullname" . }} 8080:80
{{- end }}

Kubernetes version: {{ .Capabilities.KubeVersion.Major }}.{{ .Capabilities.KubeVersion.Minor }}

10.4 Lab Task (No solution here)

Create or modify a NOTES.txt template that:

Prints the chart name, release name, and chart version.

Detects whether ingress.enabled is true.

If true, show the host and path.

If false, show a port‑forward command based on the service name and port.

Uses .Capabilities.APIVersions.Has to display which Ingress API (networking.k8s.io/v1 or v1beta1) the cluster supports.

Formats the database name from Values.database_prod.dbname in uppercase quotes using the upper and quote functions.

Solution Repository: (see example implementation)https://github.com/elevy99927/k8s/tree/main/helm/10-notes


---

## References

* [Helm Documentation](https://helm.sh/docs/)
* [ArtifactHub](https://artifacthub.io/)
* [Bitnami Helm Charts](https://bitnami.com/stacks/helm)

---

## Contact

* **Email:** [eyal@levys.co.il](mailto:eyal@levys.co.il)
* **GitHub:** [https://github.com/elevy99927](https://github.com/elevy99927)
