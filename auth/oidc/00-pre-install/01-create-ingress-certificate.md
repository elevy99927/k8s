# Replace the '192.168.49.2' IP with 
# your external IP
# copy & paste the command below

openssl req -x509 -newkey rsa:4096 -sha256 -days 3560 -nodes \
  -keyout certs/tls.key -out certs/tls.crt \
  -subj '/CN=k8soidc.192.168.49.2.nip.io' \
  -extensions san -config <(cat << EOF
[req]
distinguished_name=req
[san]
subjectAltName=@alt_names
[alt_names]
DNS.1=k8soidc.192.168.49.2.nip.io
DNS.2=192.168.49.2.nip.io
EOF
)
