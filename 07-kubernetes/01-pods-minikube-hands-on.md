# Kubernetes Pods - Minikube Hands-on Notes

## What I practised

- Starting and checking a local Minikube cluster
- Creating a Pod from a YAML definition
- Understanding YAML lists and indentation
- Generating a Pod YAML template with `kubectl`
- Using `create`, `apply`, `edit`, and `delete`
- Diagnosing YAML, cluster-connectivity, and image-pull errors

---

## 1. Minikube

Minikube creates a small Kubernetes cluster on my laptop for learning and local development.

```text
kubectl -> Minikube cluster -> Pod -> Container
```

At the beginning of a practice session:

```bash
minikube status
```

If it is stopped:

```bash
minikube start
```

Verify the cluster:

```bash
kubectl get nodes
```

Stop it after practice to save laptop resources:

```bash
minikube stop
```

- `minikube stop`: stops the cluster but preserves its resources.
- `minikube start`: starts the existing cluster again.
- `minikube delete`: deletes the cluster and everything inside it.

---

## 2. Basic Pod YAML

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
    simplylearningLabel: wow
spec:
  containers:
    - name: nginx
      image: nginx
```

### Meaning

- `apiVersion: v1`: Kubernetes API version
- `kind: Pod`: resource type
- `metadata`: information that identifies the Pod
- `name: nginx`: Pod name
- `labels`: key-value tags
- `spec`: desired Pod configuration
- `containers`: list of containers inside the Pod
- `image: nginx`: container image to run

---

## 3. Why YAML uses `-`

A hyphen means **a new item in a list**.

Simple list:

```yaml
fruits:
  - apple
  - mango
  - orange
```

One object with properties does not need hyphens:

```yaml
person:
  name: Lechu
  city: Kochi
```

List of objects:

```yaml
fruits:
  - name: apple
    color: red
  - name: mango
    color: yellow
```

Kubernetes uses the same rule:

```yaml
containers:
  - name: nginx
    image: nginx
```

A Pod can contain multiple containers, so `containers` is a list:

```yaml
containers:
  - name: nginx
    image: nginx
  - name: helper
    image: busybox
```

**Memory rule:** `-` starts a new list item. Indented lines without another hyphen provide more details about the same item.

---

## 4. YAML spacing and indentation

Incorrect:

```yaml
name:nginx
-name: nginx
```

Correct:

```yaml
name: nginx
- name: nginx
```

Rules:

- Put a space after `:`.
- Put a space after `-`.
- Use ordinary spaces for indentation, not tabs.
- Avoid special spaces introduced by copying formatted text.
- Keep child fields correctly indented under their parent.

Validate a file without creating the resource:

```bash
kubectl apply --dry-run=client -f myFirstPod.yml
```

---

## 5. Create and inspect a Pod

Create from YAML:

```bash
kubectl create -f myFirstPod.yml
```

Or create/manage it declaratively:

```bash
kubectl apply -f myFirstPod.yml
```

Inspect it:

```bash
kubectl get pods
kubectl get pods -o wide
kubectl describe pod nginx
kubectl logs nginx
```

For Nginx, empty logs can be normal until it receives a request.

---

## 6. `create` versus `apply`

### Create

```bash
kubectl create -f pod.yaml
```

Means: create this as a new resource.

- Resource does not exist: creates it.
- Resource already exists: returns `AlreadyExists`.

### Apply

```bash
kubectl apply -f pod.yaml
```

Means: make the cluster resource match this YAML definition.

- Resource does not exist: creates it.
- Resource exists: attempts to update it.

| Command | Resource absent | Resource exists |
|---|---|---|
| `create` | Creates | Fails with AlreadyExists |
| `apply` | Creates | Updates permitted fields |

**Memory rule:** `create` is for a new resource only; `apply` creates or updates from YAML.

---

## 7. Generate a Pod YAML template

KodeKloud task: create a Pod named `redis` using the intentionally incorrect image `redis123`.

Generate the file without creating the Pod:

```bash
kubectl run redis \
  --image=redis123 \
  --dry-run=client \
  -o yaml > redis.yaml
```

- `kubectl run redis`: defines a Pod named redis
- `--image=redis123`: specifies the image
- `--dry-run=client`: generates locally without creating
- `-o yaml`: produces YAML
- `> redis.yaml`: saves it to a file

Review and create it:

```bash
cat redis.yaml
kubectl create -f redis.yaml
kubectl get pods
```

The generated file resembles:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: redis
  name: redis
spec:
  containers:
    - image: redis123
      name: redis
  restartPolicy: Always
```

---

## 8. Image-pull errors

Because `redis123` is intentionally invalid, the status may progress through:

```text
ContainerCreating -> ErrImagePull -> ImagePullBackOff
```

- `ErrImagePull`: Kubernetes could not download the image.
- `ImagePullBackOff`: repeated downloads failed, so Kubernetes waits before retrying.

Diagnose it:

```bash
kubectl describe pod redis
```

Read the **Events** section at the bottom.

---

## 9. Update the image

### Edit the Pod

```bash
kubectl edit pod redis
```

Change:

```yaml
image: redis123
```

to:

```yaml
image: redis
```

In Vim, save and exit with:

```text
Esc
:wq
Enter
```

### Set the image directly

First confirm the container name:

```bash
kubectl get pod redis -o jsonpath='{.spec.containers[*].name}'
```

Then update it:

```bash
kubectl set image pod/redis redis=redis
```

General form:

```text
kubectl set image pod/POD-NAME CONTAINER-NAME=NEW-IMAGE
```

### Update the YAML

Change `image: redis123` to `image: redis` inside `redis.yaml`, then run:

```bash
kubectl apply -f redis.yaml
```

Verify:

```bash
kubectl get pod redis
```

---

## 10. Delete Pods

Delete by name:

```bash
kubectl delete pod nginx
```

Delete using the YAML definition:

```bash
kubectl delete -f myFirstPod.yml
```

Delete multiple Pods:

```bash
kubectl delete pod nginx redis
```

If a Pod is managed by a Deployment or ReplicaSet, its controller may automatically create a replacement after deletion.

---

## 11. Errors encountered

### YAML parsing error

```text
error converting YAML to JSON:
yaml: line 11: mapping values are not allowed in this context
```

Causes in the file:

```yaml
name:nginx
-name: nginx
```

Correct syntax:

```yaml
name: nginx
- name: nginx
```

The reported line is where the parser became confused; the original mistake may appear earlier.

### Connection refused

```text
The connection to the server 127.0.0.1:57576 was refused
```

Cause: Minikube and its Kubernetes API server were stopped.

Diagnose and fix:

```bash
kubectl config current-context
minikube status
minikube start
kubectl get nodes
```

A valid YAML file still requires a running Kubernetes cluster.

### Shell command-not-found errors

Examples:

```text
zsh: command not found: A-10042@LE1997
zsh: command not found: E0901
```

Cause: the terminal prompt and old terminal output were pasted back as commands.

Do not type the prompt:

```text
A-10042@LE1997 Pods %
```

Type only the command after `%`.

### VS Code schema warning

```text
Unable to load schema from '/kubernates': No content.
YAML(65536)
```

This is a VS Code schema warning, not a Minikube error.

Check for:

- Restricted Mode: trust the workspace if it is my own folder.
- A bad schema directive such as `$schema=/kubernates`.
- An incorrect `yaml.schemas` workspace setting.
- The spelling: **Kubernetes**, not `kubernates`.

A separate YAML typo seen during practice was:

```yaml
metadataa:
```

It must be:

```yaml
metadata:
```

---

## Quick command revision

```bash
# Start and verify
minikube status
minikube start
kubectl get nodes

# Generate YAML
kubectl run redis --image=redis123 --dry-run=client -o yaml > redis.yaml

# Create or apply
kubectl create -f redis.yaml
kubectl apply -f redis.yaml

# Inspect and troubleshoot
kubectl get pods
kubectl get pods -o wide
kubectl describe pod redis
kubectl logs redis

# Update
kubectl edit pod redis
kubectl set image pod/redis redis=redis

# Delete
kubectl delete pod redis
kubectl delete -f redis.yaml

# Stop local cluster
minikube stop
```

## Practice workflow

1. Check or start Minikube.
2. Verify the node is Ready.
3. Write or generate the YAML definition.
4. Create/apply the resource.
5. Check the Pod status.
6. Use `describe` and `logs` to troubleshoot.
7. Edit or apply changes when required.
8. Delete test resources when finished.
