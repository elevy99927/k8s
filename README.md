
# Kubernetes Course

## Course Overview

This course is designed to give participants a deep understanding of Kubernetes, covering everything from the basics to advanced topics like Affinity, StatefulSets, Helm, and Kubernetes security. The course includes hands-on YAML exercises from the repository to reinforce learning.

## Syllabus

### Foundation: Kubernetes Core Concepts
**Goal**: Learn Kubernetes fundamentals, its architecture, and how to deploy workloads

1. **[Introduction to Kubernetes](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-01.md)**
   - What is Kubernetes?
   - Pros and cons
   - Imperative vs. declarative
   - Kubernetes architecture overview (etcd, scheduler, API, etc.)

2. **[Key Kubernetes Components](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-02.md)**
   - Pods, Deployments, and ReplicaSets
   - Hands-on: Deploy a simple pod and a deployment
   - Services and Endpoints
   - Hands-on: Expose your deployment via a Service

3. **[YAML Basics for Kubernetes](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-03.md)**
   - YAML syntax and structure
   - Writing manifests for Pods, Deployments, and Services
   - Hands-on: Create a simple canary deployment

4. **[Namespaces and Resource Management](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-04.md)**
   - Why use namespaces?
   - Creating and managing namespaces
   - Assigning resource quotas and limits
   - Hands-on: Define namespaces and apply limits

### Workload Orchestration & Scheduling
**Goal**: Learn how Kubernetes manages and schedules workloads for high availability and scalability

5. **[Deployments and Rolling Updates](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-05.md)**
   - Creating and managing deployments
   - Rolling updates and rollbacks
   - Hands-on: Perform an update and rollback with kubectl rollout undo

6. **[StatefulSets and Persistent Storage](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-06.md)**
   - Difference between Deployments and StatefulSets
   - Persistent Volumes (PVs) and Persistent Volume Claims (PVCs)
   - Storage Classes
   - Hands-on: Deploy MySQL and Redis with persistent storage

7. **[Advance Scheduling](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-07.md)**
   - Node Selector
   - Node and Pod Affinity rules
   - Required vs. preferred scheduling
   - Taint and toleration
   - Hands-on: Modify Affinity rules in Affinity/03/all-in-one.yaml

### Kubernetes Networking & Traffic Management
**Goal**: Learn how Kubernetes handles network communication and traffic routing

8. **[Kubernetes Networking](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-08.md)**
   - Networking model and CNI plugins
   - Pod-to-Pod and Pod-to-Service communication
   - Network Policies for isolation
   - Hands-on: Secure a web app with MySQL using Network Policies

9. **[Services and Endpoints](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-09.md)**
   - ClusterIP, NodePort, LoadBalancer
   - Linking services to pods with endpoints
   - Hands-on: Deploy web-with-redis.yaml and test connectivity

10. **[Ingress Controllers and Resources](https://github.com/elevy99927/k8s/blob/main/docs/Chapter-10.md)**
    - When to use Ingress
    - Setting up an Ingress controller
    - Routing traffic using Ingress rules
    - Hands-on: Deploy an Ingress resource to expose an app
    - Hands-on: Implement canary using Ingress annotations

### Application Lifecycle & Helm

11. **[Managing Applications with Helm](https://github.com/elevy99927/k8s/tree/main/helm)**
    - Helm basics: Charts, Repositories, and Templating
    - Installing Helm and deploying applications
    - Advanced Helm: Custom Helm charts, values templating
    - Hands-on: Deploy a Helm chart and modify templates

12. **Multi-Container Pods**
    - Sidecar, Ambassador, and Adapter container patterns
    - Hands-on: Deploy a multi-container pod and test inter-container communication

13. **Pod Lifecycle, Init Containers, and Probes**
    - Pod phases and restarts
    - Init Containers for dependency management
    - Readiness, Liveness, and Startup Probes
    - Hands-on: Apply health probes to an existing application

14. **Kubernetes CronJobs & Automation**
    - Automating tasks with CronJobs
    - Hands-on: Deploy a CronJob for periodic tasks

### Advanced Kubernetes & DevOps
**Goal**: Learn production-grade scaling, security, and Kubernetes CI/CD workflows

15. **[Auto-Scaling Applications](https://github.com/elevy99927/k8s/tree/main/hpa)**
    - Horizontal vs. Vertical Pod Autoscaler (HPA, VPA)
    - Cluster Autoscaler concepts
    - Hands-on: Configure HPA for an application workload

16. **Kubernetes Permissions**
    - Kubernetes RBAC (Role-Based Access Control)
    - Securing Pods (non-root users, capabilities, secrets management)
    - Hands-on: Implement RBAC and Network Policies
    - Advance Hands-on: SSO using pinniped and github

17. **Troubleshooting and Debugging Kubernetes Applications**
    - Common failure patterns and diagnostics approaches
    - Using kubectl describe, logs, and events effectively
    - Debugging Pod startup issues and container crashes
    - Hands-on: Troubleshoot various application failure scenarios

18. **Kubernetes Observability**
    - Setting up basic monitoring with Prometheus and Grafana
    - Centralized logging approaches
    - Resource usage tracking and optimization
    - Hands-on: Deploy monitoring stack and configure basic alerts

19. **[Package Management](https://github.com/elevy99927/Jenkins-k8s/tree/main/Part1-package-manager)**
    - Node.js: Covers dependency management using package.json
    - Python: Utilizes requirements.txt and virtual environments
    - Maven: Demonstrates Java project management with pom.xml
    - Gradle: Explores build automation with build.gradle

20. **GitOps and CI/CD with Kubernetes**
    - CI/CD basics
    - Introduction to GitOps principles
    - First pipeline using Jenkins
    - Using ArgoCD for declarative deployments
    - Hands-on: Set up a basic GitOps using ArgoCD

### Final Project
**Goal**: Integrate all Kubernetes concepts with a CI/CD-driven deployment

21. **Capstone Project: Deploy a Multi-Tier Kubernetes Application**
    - Combine all concepts: Deployments, Kubernetes, Jenkins and GitOps
    
    **Section 5.1: Continuous Integration**
    - Create a secure application
    - Use multistep Docker Image
    
    **Section 5.2: Continuous Delivery**
    - Write a Jenkins pipeline
    - Create unit tests
    - Create security scan gate
    - Deploy your application (using ArgoCD)
    
    **Section 5.3: Continuous Deployment**
    - Create Canary deployment using flagger, your new application should be installed, only in case of 95% success rate
---

## Open in Google Cloud Shell

You can directly open this repository in Google Cloud Shell to start exploring the examples:

[![Open in Google Cloud Shell](https://camo.githubusercontent.com/198b1d237c4023111c3f163552130daf552a0a684ea7a8ed1adc98c9b7f59659/68747470733a2f2f677374617469632e636f6d2f636c6f75647373682f696d616765732f6f70656e2d62746e2e737667)](https://shell.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/elevy99927/k8s)


---
## Contact

For questions or feedback, feel free to reach out:

- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

