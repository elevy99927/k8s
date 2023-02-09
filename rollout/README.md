# Rollout

## Create deployment
Create deployment with 5 replicas

```
kubectl create deployment animals --image=supergiantkir/animals:bear --port 80 --replicas=5
```


## Check your pods, deployment and replicaset

```
kubectl get pods,deployment,rs
```

## Expose your deployment

```
kubectl expose deployment animals --type=LoadBalancer --port 80
```

## Check Your Service

```
kubectl get svc
```

## Update image of the deployment

```
kubectl set image deployments/animals animals=supergiantkir/animals:moose --record
```

## Check your pods, deployment and replicaset

```
kubectl get pods,deployment,rs
```


## Check rollout history

```
kubectl rollout history deployment animals 

```

## Update image of the deployment (2)

```
kubectl set image deployments/animals animals=nginx --record
```

## Check rollout history (2)

```
kubectl rollout history deployment animals 
```


## Rollout to revision X

```
kubectl rollout undo deployment animals --to-revision 2
```
