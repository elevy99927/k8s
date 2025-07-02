# Lab 9 – Helm Hooks

**Goal:** Learn how to use Helm hooks for lifecycle management.

## What Are Hooks?

Helm **hooks** are special Kubernetes resources that run at predefined points in a release lifecycle (e.g., *pre‑install*, *post‑install*, *pre‑upgrade*, *post‑delete*, and *test*).

## Key Hook Annotations

```yaml
annotations:
  # Marks this resource as a hook
  "helm.sh/hook": pre-install,pre-upgrade,test
  
  # Lower numbers run earlier
  "helm.sh/hook-weight": "1"
  
  # Automatically delete hook resources when succeeded
  "helm.sh/hook-delete-policy": hook-succeeded
```

## Hook Types:

| Annotation | Purpose |
|------------|----------|
| **`helm.sh/hook`** | Comma‑separated list of lifecycle points |
| **`helm.sh/hook-weight`** | Controls execution order within the same lifecycle point |
| **`helm.sh/hook-delete-policy`** | When Helm should delete the hook resource |

## Example Scenario

A **post-install-job.yaml** that seeds a database or runs smoke tests:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "mychart.fullname" . }}-post-install
  annotations:
    "helm.sh/hook": post-install
    "helm.sh/hook-weight": "1"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    spec:
      containers:
      - name: post-install-job
        image: busybox
        command: ['sh', '-c', 'echo "Database seeded successfully"']
      restartPolicy: Never
```

## Hook Execution Flow:

* *pre‑install*: Job runs **before** Helm creates the Deployment/Service
* *pre‑upgrade*: Same Job runs **before** upgrading an existing release
* *test*: When you call `helm test <release>`, the Job executes as integration test

---

Back to Helm Tutorial:
https://github.com/elevy99927/k8s/tree/main/helm