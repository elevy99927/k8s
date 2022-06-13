## HPA Porizontal Pod Auto Scaler

create and apply the following file `php-apache.yaml`
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  selector:
    matchLabels:
      run: php-apache
  replicas: 3
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
      - name: php-apache
        image: k8s.gcr.io/hpa-example
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: 500m
          requests:
            cpu: 200m
---
apiVersion: v1
kind: Service
metadata:
  name: php-apache
  labels:
    run: php-apache
spec:
  ports:
  - port: 80
  selector:
    run: php-apache
```

or run kubectl apply -f https://k8s.io/examples/application/php-apache.yaml
 

#create autoscaler
```
kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10

```

# check your pods and HPA
```
kubectl get deploy,hpa
```

# Create workload
```
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

```

# Check your pods
In parallel window, run the following command:

```
watch kubectl get pods,hpa

```
