##  Pods without any lable
`
kubectl get pods --all-namespaces -o go-template='{{range .items }}{{if .metadata.labels }}{{else}}{{printf "%s\n" .metadata.name}}{{ end }}{{end}}'
`

<BR>

## Pods with lable 'myapp'

`
kubectl get pods -o go-template='{{range .items }}{{if .metadata.labels.myapp }}{{printf "%s\n" .metadata.name}}{{end}}{{end}}'
`

