echo "**************************************************"
echo "you need to copy to content of k8soidc.levys.pem"
echo "end put it in 10-JWTAuthenticator.yaml"
echo "**************************************************"

echo "**************************************************"

cat k8soidc.levys.pem | base64 -w 0 ; echo
