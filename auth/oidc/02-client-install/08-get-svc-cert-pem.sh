 openssl s_client -connect k8soidc.10.100.102.82.nip.io:443 -showcerts </dev/null | openssl x509 -outform pem > k8soidc.pem
