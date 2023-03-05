kubectl create secret generic oidc-client \
  --namespace pinniped-supervisor \
  --type secrets.pinniped.dev/oidc-client \
  --from-literal=clientID="0oa5v8wup6hlMclsO5d7" \
  --from-literal=clientSecret="A_2O84bJuPx1N4zO1JISFK2tYhvBX5oyakfedH0a"

## The “Client ID” that you got from the domain admin.
#  clientID: "3e954ea8-0534-4b9e-a536-c6fc46d5c929"
# The “Client secret” that you got from the domain admin.
#  clientSecret: "VKC8Q~LPcH4hIPqETfGqUdZ_AAz_yt5g2PT71dj_"
