# ArgoCD Hands-on

## Installing ArgoCD

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=ihttps://github.com/elevy99927/k8s)  
**<kbd>CTRL</kbd> + <kbd>click</kbd> to open in new window**

---

### Create Namespace for ArgoCD
```
kubectl create ns argocd
```

### Installation
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

## Fixing ArgoCD Service
```
kubectl patch -n argocd svc argocd-server -p '{"spec":{"type":"NodePort"}}'
```


