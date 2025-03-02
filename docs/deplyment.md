
## Deployment Architecture

<img src="./images/kubernets_deployment.svg">

This illustration shows a Kubernetes Deployment managing two ReplicaSets:

1. The deployment "my-application" is shown at the top level
2. It manages two ReplicaSets:
   - ReplicaSet v1 (shown on the left with dashed lines, indicating it's being scaled down)
   - ReplicaSet v2 (shown on the right, representing the current active version)
3. Each ReplicaSet manages two pods
4. The arrows indicate the ownership relationship between components

This represents a typical scenario during a rolling update where the deployment creates a new ReplicaSet while scaling down the old one, demonstrating how Kubernetes manages application versions and updates.

## Hands-on Labs

In this section, we'll work with several Docker images including:

- `nginxdemos/hello` - A simple web server that displays hostname, IP, and headers
- `containous/whoami` - A tiny Go webserver that prints OS information and HTTP request details
- `crccheck/hello-world` - A simple hello world web server

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

