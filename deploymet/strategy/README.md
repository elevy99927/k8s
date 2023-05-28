
Create new deployment
<Li> named "kubernetes-bootcamp"
<Li> image: kubernetes-bootcamp:v1

run:
` watch kubectl get deploy,rs,po`

Update your deployment image:
`kubectl set image deployments/kubernetes-bootcamp nginx=jocatalin/kubernetes-bootcamp:v2`
  
  
view your deployment rollout:
`kubectl rollout history deploy kubernetes-bootcamp`



update your rollout status (CHANGE-CAUSE):
`kubectl annotate deployments kubernetes-bootcamp kubernetes.io/change-cause="BootCamp" `


update your rollout status (CHANGE-CAUSE) with record:
`kubectl set image deployments/kubernetes-bootcamp nginx=jocatalin/kubernetes-bootcamp:v3 --record=true`

  25 minutes
