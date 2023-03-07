kubectl -n pinniped-supervisor delete secret k8soidc-tls
kubectl -n pinniped-supervisor create secret generic k8soidc-tls --from-file=certs/tls.key --from-file=certs/tls.crt
