# Kubernetes Resource Quotas - Hands-On Exercise

## Overview
In this lab, you will practice applying **Resource Quotas** in Kubernetes. You will define quotas for **CPU, memory, object counts, and priority-based allocation** within a specific namespace.

## Step 1: Create a Namespace
Create a new namespace called `quota-lab` to apply resource quotas.

```sh
kubectl create namespace quota-lab
```

Verify the namespace:
```sh
kubectl get namespaces
```

---

## Step 2: Create Compute Resource Quotas
### **Scenario:**
You are given a namespace where developers must limit their compute resource usage. Your goal is to create a **ResourceQuota** named `compute-resources` that ensures:
- **CPU requests** cannot exceed **1 core**.
- **Memory requests** cannot exceed **1Gi**.
- **CPU limits** cannot exceed **2 cores**.
- **Memory limits** cannot exceed **2Gi**.
- A maximum of **4 GPUs** can be requested.

#### **Task:**
- Write a YAML file named **`compute-resources.yaml`** that enforces these limits.
- Apply the YAML to the `quota-lab` namespace.

Apply the quota:
```sh
kubectl apply -f compute-resources.yaml --namespace=quota-lab
```
Verify the quota:
```sh
kubectl get resourcequota -n quota-lab
```

---

## Step 3: Create Object Count Quotas
### **Scenario:**
To control the number of objects created in the namespace, you need to enforce restrictions on the following resources:
- A maximum of **10 ConfigMaps**.
- A maximum of **4 PersistentVolumeClaims**.
- A maximum of **4 Pods**.
- A maximum of **20 ReplicationControllers**.
- A maximum of **10 Secrets**.
- A maximum of **10 Services**.
- A maximum of **2 LoadBalancer Services**.

#### **Task:**
- Write a YAML file named **`object-counts.yaml`** that enforces these limits.
- Apply the YAML to the `quota-lab` namespace.

Apply the quota:
```sh
kubectl apply -f object-counts.yaml --namespace=quota-lab
```
Verify the quota:
```sh
kubectl get resourcequota -n quota-lab
```

---

## Step 4: Create Priority-Based Resource Quotas
### **Scenario:**
The cluster administrator wants to allocate resource quotas based on **Priority Classes**:
- **High Priority Pods** can use up to **1000 CPU cores**, **200Gi memory**, and **10 Pods**.
- **Medium Priority Pods** can use up to **10 CPU cores**, **20Gi memory**, and **10 Pods**.
- **Low Priority Pods** can use up to **5 CPU cores**, **10Gi memory**, and **10 Pods**.

#### **Task:**
- Write a YAML file named **`quota.yaml`** that enforces these priority-based resource allocations.
- Apply the YAML to the `quota-lab` namespace.

Apply the quota:
```sh
kubectl apply -f quota.yaml --namespace=quota-lab
```
Verify the quota:
```sh
kubectl get resourcequota -n quota-lab
```

---


