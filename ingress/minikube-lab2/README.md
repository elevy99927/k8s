# Minikube Ingress Lab 2: Host-Based Routing with nip.io

This lab demonstrates how to use host-based routing with a dynamic DNS service, `nip.io`. This allows you to use real hostnames that resolve to your Minikube IP without any manual configuration.

## Instructions

Follow these steps in your Google Cloud Shell terminal.

### 1. Start Minikube and Enable Ingress

First, ensure your Minikube cluster is running and that the `ingress` addon is enabled.

```bash
minikube start
minikube addons enable ingress
```

### 2. Apply the Deployments and Services

From within this directory (`./ingress/minikube-lab2`), apply the first YAML file to create the backend applications.

```bash
kubectl apply -f 01-deployments-services.yaml
```

### 3. Generate and Apply the Ingress Manifest

Get the IP address of your Minikube cluster and use `sed` to substitute it into the Ingress template file, then apply the resulting manifest to your cluster.

```bash
export MINIKUBE_IP=$(minikube ip)
sed "s/MINIKUBE_IP/$MINIKUBE_IP/g" 02-ingress.template.yaml | kubectl apply -f -
```

### 4. Test the Ingress Routes

Now, use `curl` to test the two different hostnames. Because `nip.io` automatically resolves `*.A.B.C.D.nip.io` to the IP address `A.B.C.D`, you no longer need the `--resolve` flag.

```bash
# Test the red hostname
curl http://red.$MINIKUBE_IP.nip.io

# Test the yellow hostname
curl http://yellow.$MINIKUBE_IP.nip.io
```

**Expected Output:**
*   The first `curl` command should return `RED`.
*   The second `curl` command should return `YELLOW`.
