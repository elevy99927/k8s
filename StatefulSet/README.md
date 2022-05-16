# StatefulSets

This sample demonstrates how Statefulsel scale pods in order


```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 10
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web

```


Deploy your StatefulSet
```bash
kubectl apply -f StatefulSet.yaml
watch kubectl get pods

```

Check for ReplicaSet (no replicaset)
```
kubectl get rs
```


Scale your StatefulSet down

```bash
kubectl scale statefulset web --replicas 1
watch kubectl get pods

```

Delete your StatefulSet
```bash
kubectl delete sts 
watch kubectl get pods

```