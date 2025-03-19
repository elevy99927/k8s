# Pod Affinity and Anti-Affinity Exercises

## Introduction

This document provides hands-on exercises to understand and implement Kubernetes Pod Affinity and Anti-Affinity rules. These scheduling constraints help manage pod placement to optimize resource usage, reduce latency, and increase availability.

## Basic Exercise: Pod Affinity

**Objective:** Schedule a frontend pod on the same node as a backend pod.

### Steps:
1. Deploy a backend pod with a specific label.
2. Deploy a frontend pod that requires co-location with the backend pod using pod affinity.

### Solution:
[Pod Affinity solution](https://github.com/elevy99927/k8s/blob/main/Affinity/affinity-labs.md)


### Validation:
Run the following command to check the pod placement:

```sh
kubectl get pods -o wide
```

Verify that both pods are scheduled on the same node.

---

## Advanced Exercise: Pod Anti-Affinity

**Objective:** Ensure that MySQL and Backend pods are scheduled together, but Frontend cannot be scheduled with MySQL.

### Steps:
1. Deploy a frontend pod that can run anywhere.
2. Deploy a MySQL pod that should not be scheduled on the same node as the frontend.
3. Deploy a backend pod that must be scheduled with MySQL.

### Solution:
[Advance Pod Affinity solution](https://github.com/elevy99927/k8s/blob/main/Affinity/advance-pod-antiaffinity.yaml)

### Validation Steps:
1. Deploy the frontend pod.
2. Deploy the MySQL pod.
3. Deploy the backend pod.
4. Observe that MySQL and Backend remain **pending**.
5. Delete the frontend pod.
6. MySQL and Backend should now be scheduled and running.

### Discussion:
- What will happen if you try to start the frontend pod again?
- Why does this happen?

---

## Summary

- **Pod Affinity** ensures that related pods run on the same node to reduce latency.
- **Pod Anti-Affinity** ensures that certain pods do not run on the same node to improve availability.
- These techniques are useful for applications requiring high availability and resource optimization.

**Next Steps:**
- Modify these examples by changing `requiredDuringSchedulingIgnoredDuringExecution` to `preferredDuringSchedulingIgnoredDuringExecution` and observe how Kubernetes prioritizes but does not enforce these constraints.
- Experiment with different `topologyKey` values to control placement at different levels (e.g., across availability zones).

