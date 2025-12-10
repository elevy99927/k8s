# Minikube Ingress Lab: Path-Based Routing

This lab demonstrates how to use the NGINX Ingress controller on Minikube to route traffic to different backend services based on the request's URL path.

## Instructions

Follow these steps in your Google Cloud Shell terminal.

### 1. Start Minikube and Enable Ingress

First, ensure your Minikube cluster is running and that the `ingress` addon is enabled.

```bash
minikube start
minikube addons enable ingress
```

### 2. Apply the Kubernetes Manifests

From within this directory (`./ingress/minikube-lab1`), apply all the YAML files to create the deployments, services, and the ingress resource.

```bash
kubectl apply -f .
```

### 3. Test the Ingress Routes

Get the IP address of your Minikube cluster.

```bash
MINIKUBE_IP=$(minikube ip)
```

Now, use `curl` to test the two different paths. You don't need a hostname for this example since the Ingress rule doesn't specify one.

```bash
# Test the /red path
curl http://$MINIKUBE_IP/red

# Test the /yellow path
curl http://$MINIKUBE_IP/yellow
```

**Expected Output:**
*   The first `curl` command should return `RED`.
*   The second `curl` command should return `YELLOW`.
