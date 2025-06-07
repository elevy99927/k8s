### 4. LAB 2: Canary Deployment Using Header

Create two versions of the `green` service. One will be treated as the canary.
<BR>Create canary deployment using HTTP headers.
<BR>1. Default image will be nginx with port 80
<BR>2. Canary image will be elevy99927/color:green

**Your task:**
<BR>Create ingress rule to route users with header `"x-canary: always"` to the Canary image
Test with header:

```sh
curl -H "x-canary: always" http://<EXTERNAL-IP>/green
```

---
### **Back to Ingress session**
<A href="https://github.com/elevy99927/k8s/blob/main/docs/Chapter-10.md">Ingress Controllers and Resources</A>

---
## **Contact**
For questions or feedback, feel free to reach out:
- **Email**: eyal@levys.co.il
- **GitHub**: [https://github.com/elevy99927](https://github.com/elevy99927)

