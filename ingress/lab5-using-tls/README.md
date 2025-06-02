

### 5. Advanced Lab - Secure Ingress with TLS**

Objective: Use a self-signed certificate to encrypt traffic.

Steps:

1. Generate TLS cert and key:

```sh
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -out tls.crt -keyout tls.key -subj "/CN=example.com/O=example"
```

2. Create secret with your tls key:

```sh
kubectl create secret tls tls-secret --key tls.key --cert tls.crt
```

3. Add `tls` block to ingress:

```yaml
spec:
  tls:
  - hosts:
    - example.com
    secretName: tls-secret
```

4. Add `/etc/hosts` entry pointing `example.com` to the Ingress IP
5. Use `curl -k https://example.com/...`

This lab adds security and prepares learners for real-world deployments.
