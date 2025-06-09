
# Helm Tutorial for Kubernetes

---

## 1. What is a Package Manager?

A **package manager** is a tool that automates installing, upgrading, configuring, and removing software applications. In traditional software, package managers like `apt` (Ubuntu), `yum` (RHEL), or `npm` (Node.js) simplify managing software dependencies and updates.

**In Kubernetes:**
A package manager helps you manage complex Kubernetes applications by grouping multiple resource manifests and templates together, making installation and upgrades easy and repeatable.

---

## 2. Why Helm?

**Helm** is the de-facto package manager for Kubernetes.
It solves several challenges in Kubernetes deployments:

* **Template Reuse:** Parameterize YAML with variables.
* **Consistency:** Avoid manual YAML editing for each environment.
* **Versioning:** Upgrade, rollback, and manage releases.
* **Complex Deployments:** Package multiple resources (Deployment, Service, Ingress, etc.) together.
* **Community Ecosystem:** Reuse existing charts from others.

**Example Use Cases:**

* Deploying Nginx, databases, monitoring tools (Prometheus, Grafana), or in-house apps.
* Managing different configs (dev, staging, prod) with a single source.

---

## 3. Helm Alternatives

* **Kustomize:**
  Built-in to `kubectl`. Focuses on patching YAMLs for different environments. Simpler, but less powerful templating.
* **Kapp (from Carvel):**
  Focus on simple app lifecycle, dependency management, and auditability.
* **Operator Frameworks (e.g., Operator SDK, OLM):**
  For more complex applications requiring custom logic.
* **DIY Scripting (kubectl + Bash/Python):**
  Used, but lacks consistency, templating, and release management features of Helm.

*Most large-scale production teams use Helm due to its ecosystem and power.*

---

## 4. [ArtifactHub.io](https://artifacthub.io/)

[Artifact Hub](https://artifacthub.io/) is the central public repository for Kubernetes Helm charts, OLM operators, and other artifacts.

* **Discover:** Find charts for common apps (nginx, prometheus, postgres, etc.)
* **Install:** Follow copy-paste instructions to install directly with Helm.
* **Publish:** Teams can share and maintain their own charts for the community.

*Example: Search "nginx" → pick a chart → see install/upgrade/values info.*

---

## 5. Helm Concepts

### Chart Structure

```
myapp/
├── Chart.yaml       # Metadata (name, version, description)
├── values.yaml      # Default config values
└── templates/       # Parameterized resource templates (YAML)
```

### Values

* **values.yaml** – default values for all parameters.
* **values-dev.yaml** – alternative values for dev/testing environments.
* **Override Values at Install/Upgrade:**

  * `helm install myapp ./myapp -f values-dev.yaml`
  * `helm install myapp ./myapp --set image.tag=1.2.3`

### Chart Installation Flow

1. **Install:**
   `helm install myapp ./myapp`
2. **Upgrade:**
   `helm upgrade myapp ./myapp --set image.tag=2.0.0`
3. **Rollback:**
   `helm rollback myapp 1`
4. **Uninstall:**
   `helm uninstall myapp`

### Best Practices

* Use values files for environment overrides.
* Template everything (resources, names, labels, env variables).
* Document values in `values.yaml`.
* Keep templates DRY (use `_helpers.tpl`).
* Pin chart versions in production.

---

## 6. Helm Installation


### Install Helm

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

```

### Helm config and CLI Basics
* Run `helm version`, `helm help`.
* Add the Bitnami repo:
  `helm repo add bitnami https://charts.bitnami.com/bitnami`
* Update repo:
  `helm repo update`

### Deploy Your First Helm Chart

* Search for nginx:
  `helm search repo nginx`
* Install nginx:
  `helm install my-nginx bitnami/nginx`
* Check resources:
  `kubectl get all`

### Inspect and Upgrade Releases

* Inspect release:
  `helm list`, `helm status my-nginx`
* Upgrade:
  `helm upgrade my-nginx bitnami/nginx --set service.type=LoadBalancer`
* Roll back:
  `helm rollback my-nginx 1`

## 7. Working with Helm

### Lab 1: Create a ConfigMap Using Helm

**Objective:**

Create a simple Helm chart that deploys a Kubernetes ConfigMap using a template.

**Steps:**

1. **Initialize a new chart:**

   ```sh
   helm create myapp
   ```
2. **Clean up template directory:**
   Delete all files in `myapp/templates/`:

   ```sh
   rm -rf myapp/templates/*
   ```
3. **Create the ConfigMap template:**
   Create a file called `myapp/templates/configmap.yaml` with the following content:

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: myapp-cm
   data:
     dbname: "db-mysql"
     dbtable: "music"
   ```
4. **Install the chart:**

   ```sh
   helm install myapp ./myapp
   ```

**Validation:**

* Check that the ConfigMap was created:

  ```sh
  kubectl get configmap
  kubectl get configmap myapp-cm -o yaml
  ```

Try to install another application.


---

### Lab 2: Reuse ConfigMap Using Helm

**Objective:**

Reuse your Helm chart using **Built-in Objects.**

[https://helm.sh/docs/chart\_template\_guide/builtin\_objects/](https://helm.sh/docs/chart_template_guide/builtin_objects/)

**Steps:**

1. **Initialize a new chart:**

   ```
   helm create myapp
   ```
2. **Clean up template directory:** Delete all files in `myapp/templates/`:

   ```
   rm -rf myapp/templates/*
   ```
3. **Create the ConfigMap template:** Create a file called `myapp/templates/configmap.yaml` with the following content:

   ```
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: {{ .Release.Name }}-cm
   data:
     dbname: "db-mysql"
     dbtable: "music"
     k8s: {{ .Capabilities.KubeVersion }}
   ```
4. **Install the chart:**

   ```
   helm install myapp ./myapp
   ```

**Validation:**

* Check that the ConfigMap was created:

  ```
  kubectl get configmap
  kubectl get configmap myapp-cm -o yaml
  ```

---



### Lab 3: Dynamic ConfigMap with values.yaml

**Objective:**
Make your ConfigMap dynamic by sourcing values from `values.yaml`.

**About values.yaml:**
The `values.yaml` file allows you to define configuration values that can be referenced inside your Helm chart templates. By using these values, you can easily customize Kubernetes manifests for different environments, override defaults at install/upgrade time, and keep your templates reusable and DRY.

* Example:

  ```yaml
  dbname: "db-mysql"
  dbtable: "music"
  image: "nginx"
  tag: "1.25"
  ```
* You can override these at install time:

  ```sh
  helm install myapp ./myapp --set dbname=customdb
  ```

**Steps:**

1. **Edit values.yaml:**
   Add the following values to your `myapp/values.yaml`:

   ```yaml
   dbname: "db-mysql"
   dbtable: "music"
   image: "nginx"
   tag: "1.25"
   ```
2. **Edit configmap.yaml:**
   Update `myapp/templates/configmap.yaml` to reference the values from `values.yaml`:

   ```yaml
   apiVersion: v1
   kind: ConfigMap
   metadata:
     name: {{ .Release.Name }}-cm
   data:
     dbname: {{ .Values.dbname }}
     dbtable: {{ .Values.dbtable }}
     image: {{ .Values.image }}:{{ .Values.tag }}
     k8s: {{ .Capabilities.KubeVersion }}
   ```
3. **Install the chart:**

   ```sh
   helm install myapp ./myapp
   ```

**Validation:**

* Check the ConfigMap:

  ```sh
  kubectl get configmap
  kubectl get configmap myapp-cm -o yaml
  ```

---

Lab 4 

Lab 5

...

Lab 10

## **References:**

* [Helm Docs](https://helm.sh/docs/)
* [ArtifactHub](https://artifacthub.io/)
* [Bitnami Helm Charts](https://bitnami.com/stacks/helm)


---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---