# Kubernetes Storage: Understanding PV, PVC, and StorageClass

This document explains the core concepts of persistent storage in Kubernetes: `PersistentVolumes` (PVs), `PersistentVolumeClaims` (PVCs), and `StorageClasses`. We will use a practical example to demonstrate how they work together.

## 1. Core Concepts

In Kubernetes, Pods are ephemeral. When a Pod is destroyed, any data saved inside its container is lost. To store data permanently, we need to use persistent storage.

- **`PersistentVolume` (PV):** A PV is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using a `StorageClass`. It is a cluster resource, just like a CPU or a node. It has a lifecycle independent of any individual Pod that uses the PV.

- **`PersistentVolumeClaim` (PVC):** A PVC is a request for storage by a user. It is similar to a Pod. Pods consume node resources, and PVCs consume PV resources. A PVC requests a specific size and access mode (e.g., `ReadWriteOnce`).

- **`StorageClass`:** A `StorageClass` provides a way for administrators to describe the "classes" of storage they offer. Different classes might map to different storage backends, performance levels, or backup policies. `StorageClasses` are the key to enabling **dynamic provisioning**, which automatically creates a PV when a PVC requests it.

---

## 2. The Scenario: Dynamic Provisioning in Action

Let's explore a common scenario where a Pod needs persistent storage. We will see why the order of creating resources matters.

Most Kubernetes environments, including Minikube, come with a default `StorageClass` pre-installed. This class is used to dynamically provision storage whenever a PVC is created without explicitly specifying a class.

You can see the available `StorageClasses` by running:

```bash
kubectl get storageclass
```

The output will look something like this, with `standard` marked as the default:

```
NAME                 PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
standard (default)   k8s.io/minikube-hostpath       Delete          Immediate           false                  20m
```

### 3. Applying a Pod Before Its PVC Exists

Let's say we have a Pod definition in a file named `01-pod.yaml` that requires a PVC named `my-pvc`.

**`01-pod.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: app-container
    image: nginx
    volumeMounts:
    - name: my-storage
      mountPath: /usr/share/nginx/html
  volumes:
  - name: my-storage
    persistentVolumeClaim:
      claimName: my-pvc # This PVC does not exist yet!
```

If you apply this file first, the Pod will not start.

```bash
kubectl apply -f 01-pod.yaml
```

When you check the Pod's status, it will be stuck in the `Pending` state. Using `kubectl describe pod my-app` reveals why:

```
Events:
  Type     Reason              Age                  From               Message
  ----     ------              ----                 ----               -------
  Warning  FailedScheduling    <unknown>            default-scheduler  0/1 nodes are available: 1 node(s) didn't find available persistent volumes to bind.
```

The Kubernetes scheduler cannot start the Pod because its required volume, `my-pvc`, does not exist.

### 4. Applying the PVC and Starting the Pod

Now, let's define the `PersistentVolumeClaim` in a file named `02-pvc.yaml`.

**`02-pvc.yaml`**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

When you apply this file, the magic of dynamic provisioning happens:

```bash
kubectl apply -f 02-pvc.yaml
```

**Why does the Pod start now?**

1.  When `02-pvc.yaml` is applied, Kubernetes sees a new PVC named `my-pvc`.
2.  Because the PVC does not specify a `storageClassName`, Kubernetes uses the **default `StorageClass`** (`standard` in Minikube).
3.  The provisioner for the `standard` StorageClass (`k8s.io/minikube-hostpath`) automatically creates a `PersistentVolume` (PV) that satisfies the claim's request (1Gi, ReadWriteOnce).
4.  Kubernetes binds this new PV to the `my-pvc` claim.
5.  Now that the `my-pvc` claim is fulfilled and bound, the scheduler finds that the volume requirement for the `my-app` Pod is met.
6.  The scheduler proceeds to start the Pod on a suitable node.

### 5. Describing the PV and PVC

You can inspect the results of the dynamic provisioning process with `kubectl describe`.

```bash
kubectl describe pvc,pv
```

You will see that the PVC `my-pvc` is now in a `Bound` state and is bound to a dynamically created PV. The PV will also show its status as `Bound` to the `my-pvc` claim. This confirms that the storage is ready and attached, allowing the Pod to run.

```bash
#kubectl describe pv
...
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      100Mi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       pv-pod
Events:
  Type    Reason                 Age    From                                                                    Message
  ----    ------                 ----   ----                                                                    -------
  Normal  Provisioning           4m12s  k8s.io/minikube-hostpath_minikube_26361250-4f59-48cf-8902-130db50de609  External provisioner is provisioning volume for claim "default/my-pvc"
  Normal  ExternalProvisioning   4m12s  persistentvolume-controller                                             Waiting for a volume to be created either by the external provisioner 'k8s.io/minikube-hostpath' or manually by the system administrator. If volume creation is delayed, please verify that the provisioner is running and correctly registered.
  Normal  ProvisioningSucceeded  4m12s  k8s.io/minikube-hostpath_minikube_26361250-4f59-48cf-8902-130db50de609  Successfully provisioned volume pvc-32939c88-4e40-4075-b773-837eb24e187a


---

#kubectl describe pv
Name:            pvc-32939c88-4e40-4075-b773-837eb24e187a
Labels:          <none>
Annotations:     hostPathProvisionerIdentity: 6b8ce295-6b0f-41fe-b2af-4ec24711ec98
                 pv.kubernetes.io/provisioned-by: k8s.io/minikube-hostpath
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:    standard
Status:          Bound
Claim:           default/my-pvc
Reclaim Policy:  Delete
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        100Mi
Node Affinity:   <none>
Message:         
Source:
    Type:          HostPath (bare host directory volume)
    Path:          /tmp/hostpath-provisioner/default/my-pvc
    HostPathType:  
Events:            <none>
