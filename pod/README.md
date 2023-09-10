## Create Pod

`
kubectl run mypod --image nginx
`

## List your pods (1)
`
kubectl get pod --show-labels
`



## Lable pod

`
kubectl label pod mypod app=someapp
`

## List your pods (2)
`
kubectl get pod --show-labels
`


