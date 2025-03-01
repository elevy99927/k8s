## Foundation: Kubernetes Core Concepts

Goal: Learn Kubernetes fundamentals, its architecture, and how to deploy workloads

## 1. Introduction to Kubernetes 

### What is Kubernetes?

Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. It was originally developed by Google and is now maintained by the Cloud Native Computing Foundation (CNCF).

### Pros and Cons of Kubernetes

#### Pros:

- **Scalability**: Automatically scales applications based on demand.
- **Self-healing**: Restarts failed containers and replaces unresponsive nodes.
- **Load Balancing**: Distributes traffic efficiently among application instances.
- **Declarative Configuration**: Uses YAML/JSON files to define desired state.
- **Portability**: Works across cloud providers and on-premises data centers.
- **Rolling Updates**: Updates applications without downtime.

#### Cons:

- **Complexity**: Steep learning curve for new users.
- **Organizational Change**: Requires significant shifts in QA, DevOps, and security methodologies to align with containerized workflows.
- **Resource Intensive**: Requires significant CPU, memory, and storage resources.
- **Networking Overhead**: Complex networking model for managing communication.
- **Configuration Management**: Requires proper YAML configuration to function correctly.

## Imperative vs. Declarative Management

Kubernetes supports two approaches to managing resources:

- **Imperative Management**: Commands are issued directly to create or modify resources (e.g., `kubectl run` to start a pod).
- **Declarative Management**: Resources are defined in YAML or JSON files and applied using `kubectl apply`, ensuring the cluster matches the desired state.

## Kubernetes Architecture Overview

Kubernetes consists of several core components that work together to manage containerized applications efficiently:

### Control Plane Components:

- **API Server** (`kube-apiserver`): Acts as the gateway for all Kubernetes API requests.
- **Scheduler** (`kube-scheduler`): Assigns Pods to available nodes based on resource requirements.
- **Controller Manager** (`kube-controller-manager`): Ensures the desired state of the cluster is maintained (e.g., scaling replicas, monitoring nodes).
- **etcd**: A distributed key-value store that holds cluster configuration and state.

### Node Components:

- **Kubelet**: The agent running on each node, responsible for managing containers and reporting back to the control plane.
- **Kube Proxy**: Handles networking and load balancing between Pods and external services.
- **Container Runtime**: The software responsible for running containers (e.g., Docker, containerd, CRI-O).

---
---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

---
### **Next Steps**
<A href="./Chapter-02.md">Key Kubernetes Components </A>