# Lab 7 – Conditional Ingress with If-Else Logic

**Goal:** Implement conditional Ingress creation based on values.

## Features:

- Conditional rendering using `{{ if .Values.ingress.enabled }}`
- Dynamic host and path configuration
- Service backend configuration from values
- Ingress class and annotations support

## Example conditional template:

```yaml
{{- if .Values.ingress.enabled -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "mychart.fullname" . }}
  {{- if .Values.ingress.annotations }}
  annotations:
    {{- toYaml .Values.ingress.annotations | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.className }}
  ingressClassName: {{ .Values.ingress.className }}
  {{- end }}
  rules:
    - host: {{ .Values.ingress.host | quote }}
      http:
        paths:
          - path: {{ .Values.ingress.path }}
            pathType: {{ .Values.ingress.pathType }}
            backend:
              service:
                name: {{ include "mychart.fullname" . }}
                port:
                  number: {{ .Values.service.port }}
{{- end }}
```

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm