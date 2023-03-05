# Ingress Installation

Please check that you have ingress nginx installed 
on your cluster.
if no ingress installed, please install.
You can use the followinf command to install the ingress.

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/aws/deploy.yaml
```

# Verify installation:
(check that the LB is available)

```
kubectl get svc -n ingress-nginx ingress-nginx-controller
```
