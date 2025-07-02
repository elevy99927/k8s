# Lab 10 – NOTES.txt and .Capabilities

**Goal:** Demonstrate how to deliver dynamic post‑install guidance using Helm's NOTES.txt template and the .Capabilities object.

## What is NOTES.txt?

NOTES.txt is a special Helm template rendered after an install or upgrade. Its output is printed to the user's console.

* **Onboarding:** Give immediate next‑steps (e.g., kubectl port‑forward, browser URLs)
* **Contextual info:** Show different instructions depending on service type, ingress enablement, or cluster version
* **Automation hints:** CI pipelines can parse the output for dynamic environment details

## Mini Example NOTES.txt:

```
CHART NAME: {{ .Chart.Name }}
RELEASE NAME: {{ .Release.Name }}

{{- if .Values.ingress.enabled }}
Your application is exposed via Ingress → http://{{ .Values.ingress.host }}/
{{- else }}
Service Type: {{ .Values.service_type }}
Run: kubectl port-forward svc/{{ include "mychart.fullname" . }} 8080:80
{{- end }}

Kubernetes version: {{ .Capabilities.KubeVersion.Major }}.{{ .Capabilities.KubeVersion.Minor }}
```

## Lab Task:

Create a NOTES.txt template that:

1. Prints the chart name, release name, and chart version
2. Detects whether ingress.enabled is true
3. If true, show the host and path
4. If false, show a port‑forward command based on service name and port
5. Uses .Capabilities.APIVersions.Has to display which Ingress API the cluster supports
6. Formats the database name from Values.database_prod.dbname in uppercase quotes

## Capabilities Object:

The `.Capabilities` object provides information about the Kubernetes cluster:

* `.Capabilities.KubeVersion` - Kubernetes version info
* `.Capabilities.APIVersions` - Available API versions
* `.Capabilities.HelmVersion` - Helm version info

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm