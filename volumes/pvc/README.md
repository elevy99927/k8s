# Advanced Lab: Create a MySQL StatefulSet with Persistent Storage

## Overview
In this lab, you will create a **StatefulSet** for MySQL with persistent storage using a **VolumeClaimTemplate**. The objective is to define a persistent and stable database deployment in Kubernetes.

### **Instructions:**
1. Create a **MySQL StatefulSet** named `mysql`.
2. Use an **environment variable** `MYSQL_ROOT_PASSWORD` for password configuration.
3. Define a **Persistent Volume Claim (PVC)** named `mysql-storage` with:
   - Storage size: **5Gi**
   - Access mode: **ReadWriteOnce**
4. Deploy the **StatefulSet** and verify persistence across pod restarts.

---

## **Step 1: Define the MySQL StatefulSet YAML**
Create a file named `mysql-statefulset.yaml` and include the following configuration:

---

## **Step 2: Deploy the MySQL StatefulSet**
Apply the YAML to deploy MySQL:
```sh
kubectl apply -f mysql-statefulset.yaml
```

Verify that the StatefulSet has been created:
```sh
kubectl get statefulset
```

---

## **Step 3: Verify Persistent Storage**
Check if the Persistent Volume Claim (PVC) has been created:
```sh
kubectl get pvc
```

Check the pod status and its persistent volume:
```sh
kubectl get pods -o wide
```

Delete the MySQL pod and verify persistence:
```sh
kubectl delete pod mysql-0
kubectl get pods
```

Once the pod restarts, the data should still be present.

---

## **Lab Solution**
[MySQL StatefulSet with Persistent Storage](https://github.com/elevy99927/k8s/blob/main/volumes/pvc/solution/mysql-with-pvc.yaml)

