echo kubectl config set-credentials myuser
kubectl config set-credentials myuser --client-certificate=myuser.crt --client-key=myuser.key
echo Done

echo
echo kubectl config set-context myuser-context
kubectl config set-context myuser-context --cluster=kubernetes --namespace demo-ns --user=myuser

echo Done.

echo view your new context
kubectl config get-contexts


echo Switching to the new context
kubectl config use-context myuser-context
