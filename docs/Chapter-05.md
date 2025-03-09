# Deployments and Rolling Updates

## 1. Deployment Strategies
A **Deployment** in Kubernetes is used to manage application updates and ensure high availability. There are different strategies for deploying changes:

### **Recreate Strategy**
- Terminates all existing pods before creating new ones.
- Causes downtime but ensures all pods run the updated version.

### **Rolling Update (Default Strategy)**
- Gradually replaces old pods with new ones.
- Ensures zero downtime by keeping some instances available during the update.

### **Blue-Green Deployment** *(Requires manual service switch)*
- A new version (Green) is deployed alongside the old version (Blue).
- Traffic is switched from Blue to Green when ready.

### **Canary Deployment**
- A small percentage of traffic is routed to the new version.
- If successful, traffic gradually shifts to the updated version.

---

## 2. Creating and Managing Deployments
To create a **Deployment** with multiple replicas:
```sh
kubectl create deployment animals --image=supergiantkir/animals:bear --port 8080 --replicas=5
```
Verify that the deployment, pods, and ReplicaSet were created:
```sh
kubectl get pods,deployment,rs
```

Expose the deployment as a **Service**:
```sh
kubectl expose deployment animals --type=NodePort --port=80
```
Check the service details:
```sh
kubectl get svc
```

Access the application in your browser:
```
http://your_Svc_IP:80
```
You should see the **bear** image.

---

## 3. Rolling Updates and Rollbacks
### **Performing a Rolling Update**
To update the deployment and change the application image:
```sh
kubectl set image deployments/animals animals=supergiantkir/animals:moose --record
```
Verify the update:
```sh
kubectl get pods,deployment,rs
```
Access the application again:
```
http://your_Svc_IP:80
```
You should now see the **moose** image.

### **Check Deployment History**
```sh
kubectl rollout history deployment animals
```

### **Perform Another Update**
```sh
kubectl set image deployments/animals animals=nginx --record
```
Check the application again:
```
http://your_Svc_IP:80
```
You should now see the **nginx** default page.

### **Rolling Back to a Previous Version**
To undo the last update and restore a previous version:
```sh
kubectl rollout undo deployment animals --to-revision=2
```
This restores the deployment to the version before the update.

---

## Hands-on: Perform an Update and Rollback with `kubectl rollout undo`
Please refar to the lab [Perform an Update and Rollback](https://github.com/elevy99927/k8s/tree/main/rollout)


---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-06.md">StatefulSets and Persistent Storage</A>