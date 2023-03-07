# Use the client ID and secret from Okta web application
# https://dev-<YOURID>-admin.okta.com/admin/apps/active 
kubectl create secret generic oidc-client \
  --namespace pinniped-supervisor \
  --type secrets.pinniped.dev/oidc-client \
  --from-literal=clientID="0oa8im7mw4pGa3hHH5d7" \
  --from-literal=clientSecret="e1GGqDenvDPXP1MG3dJ8GXP5R4pcCv9ag4nDzfXn"

