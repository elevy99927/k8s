 openssl s_client -connect k8soidc.levys.co.il:443 -showcerts </dev/null | openssl x509 -outform pem > k8soidc.levys.pem
