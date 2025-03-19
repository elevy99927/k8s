# StatefulSets and Persistent Storage

## 1. Difference Between Deployments and StatefulSets

**Deployments** and **StatefulSets** are both used to manage Kubernetes workloads, but they serve different purposes:

| Feature      | Deployment               | StatefulSet                                             |
| ------------ | ------------------------ | ------------------------------------------------------- |
| Pod Identity | Pods are interchangeable | Pods have unique, persistent identities                 |
| Scaling      | Any pod can be replaced  | Each pod maintains a stable network identity            |
| Storage      | Ephemeral by default     | Uses Persistent Volumes to maintain data                |
| Use Cases    | Stateless applications   | Databases, distributed systems (e.g., MySQL, Cassandra) |

StatefulSets ensure that pods are started, scaled, and deleted in order while maintaining persistent storage.

---

## 2. Persistent Volumes (PVs) and Persistent Volume Claims (PVCs)

### **Persistent Volumes (PVs)**

A **Persistent Volume (PV)** is a cluster-wide storage resource that provides long-term storage for applications. It is independent of the Pod lifecycle.

### **Persistent Volume Claims (PVCs)**

A **Persistent Volume Claim (PVC)** is a request for storage by a Pod. It allows users to specify storage requirements (size, access mode) without needing to manage the underlying storage infrastructure.

#### **Example: PVC Definition**

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: jb-claim
  annotations:
    volume.beta.kubernetes.io/storage-class: "default"
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Apply the PVC:

```sh
kubectl apply -f simple-pvc.yaml
```
Link to [simple-pvc.yaml](https://github.com/elevy99927/k8s/blob/main/volumes/pvc/simple-pvc.yaml).

---

## 3. Storage Classes Mechanism

Storage Classes define the different types of storage available in the cluster. They allow dynamic provisioning of Persistent Volumes.

### **Example Storage Class Definition**

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-storage
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2
```

- **provisioner**: Determines how the volume is created (e.g., AWS EBS, GCE PD, NFS).
- **parameters**: Specifies backend storage type and performance requirements.

To list available storage classes:

```sh
kubectl get storageclass
```

---

## 4. Understanding VolumeClaimTemplate in StatefulSets

Unlike Deployments, StatefulSets use **VolumeClaimTemplates** to dynamically provision persistent storage for each Pod. Each Pod in a StatefulSet gets its own Persistent Volume (PV), ensuring data persistence across restarts.

### **How VolumeClaimTemplate Works**
- Each Pod in the StatefulSet gets a uniquely named Persistent Volume Claim (PVC).
- The name format is `<volumeClaimTemplate-name>-<pod-name>` (e.g., `mysql-storage-mysql-0`).
- These PVCs are automatically created when the StatefulSet is deployed.

### **Example VolumeClaimTemplate Definition**
```yaml
volumeClaimTemplates:
- metadata:
    name: mysql-storage
  spec:
    accessModes: ["ReadWriteOnce"]
    resources:
      requests:
        storage: 5Gi
```

Each Pod gets its own Persistent Volume, ensuring stateful behavior required for databases like MySQL.

---

## 5. Hands-on: Create StatefulSet with Persistent Storage
For a complete guided lab, follow the instructions in the [StatefulSet Persistent Storage Lab](https://github.com/elevy99927/k8s/tree/main/volumes/pvc).

Check the Persistent Volume Claim:

```sh
kubectl get pvc
```

Check the StatefulSet status:

```sh
kubectl get statefulset
```

---

Next, we will explore **Advanced Scheduling**, covering Node Selectors, Affinity, and Taints & Tolerations.


---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-07.md">Kuberetes Advance Scheduling</A>