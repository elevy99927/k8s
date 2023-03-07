echo read certificate from kubernetes
kubectl get csr myuser -o=jsonpath='{.status.certificate}' |base64 -d > myuser.crt
echo Done.
echo
echo view certificate:
cat myuser.crt
