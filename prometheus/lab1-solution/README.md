# Lab Solution for Metrics App

For this lab, we will use the `open-o11y/prometheus-sample-app` Docker image. This image generates all four Prometheus metric types (counter, gauge, histogram, summary) and exposes them at the `/metrics` endpoint.


### Deployment YAML:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-sample-app-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: prometheus-sample-app
  template:
    metadata:
      labels:
        app: prometheus-sample-app
    spec:
      containers:
        - name: prometheus-sample-app
          image: open-o11y/prometheus-sample-app
          ports:
            - containerPort: 8080
```

### Service YAML:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus-sample-app-service
  labels:
    app: prometheus-sample-app
spec:
  selector:
    app: prometheus-sample-app
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
```

### PodMonitor YAML:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PodMonitor
metadata:
  name: prometheus-sample-app-monitor
spec:
  selector:
    matchLabels:
      app: prometheus-sample-app
  podMetricsEndpoints:
    - port: 8080
      path: /metrics
```

