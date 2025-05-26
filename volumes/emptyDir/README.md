## Lab: Run a Pod with an `emptyDir` Volume

**Goal:**
Understand how to use an `emptyDir` volume to share temporary storage between containers in the same Pod.

**Reference Files:**
👉 [GitHub - volumes/emptyDir](https://github.com/elevy99927/k8s/tree/main/volumes/emptyDir)

---

### 🧱 Background

`emptyDir` is a volume type in Kubernetes that provides ephemeral storage that lives as long as the Pod does. It is often used for:

* Sharing data between containers in the same Pod.
* Providing scratch space for computations.

---

### 🛠️ Step-by-Step Instructions

#### Step 1: Inspect the YAML

Here is an example Pod specification using `emptyDir`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shared-data-pod
spec:
  containers:
  - name: writer
    image: busybox
    command: ["sh", "-c", "echo shared data > /data/hello.txt; sleep 3600"]
    volumeMounts:
    - mountPath: /data
      name: shared-volume

  - name: reader
    image: busybox
    command: ["sh", "-c", "sleep 5; cat /data/hello.txt; sleep 3600"]
    volumeMounts:
    - mountPath: /data
      name: shared-volume

  volumes:
  - name: shared-volume
    emptyDir: {}
```

This Pod has two containers:

* `writer` writes a file into `/data`
* `reader` waits a few seconds and reads the file from `/data`

#### Step 2: Apply the Pod

```bash
kubectl apply -f https://raw.githubusercontent.com/elevy99927/k8s/main/volumes/emptyDir/emptydir.yaml
```

#### Step 3: Validate Output

Check the logs from the `reader` container:

```bash
kubectl logs shared-data-pod -c reader
```

✅ You should see:

```
shared data
```

#### Step 4: Cleanup

```bash
kubectl delete pod shared-data-pod
```

---

### 📦 Bonus: memory-backed `emptyDir`

To create an `emptyDir` volume that uses RAM instead of disk:

```yaml
emptyDir:
  medium: Memory
```

Useful for high-performance temporary caching.

---

Let me know if you want an advanced lab with multi-container apps using `emptyDir` for logging or socket sharing.
