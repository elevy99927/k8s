# Lab 8 – Reusable Helpers (`_helpers.tpl`)

**Goal:** Learn how to place common logic in **named templates** inside `_helpers.tpl` so every manifest can call the same helper instead of duplicating code.

## Why helpers?

* Keep templates **DRY** – branding, naming, or label logic lives in one place.
* Enforce consistency: a single function defines how resources are named or annotated.
* Easier maintenance: update the helper once, all templates inherit the change.

## Example helper snippet

Add this to `_helpers.tpl`:

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

## Usage in a Deployment manifest:

```yaml
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
{{ include "mychart.labels" . | indent 4 }}
```

## Advanced helper usage example

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

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm