# Verify Installation

```bash
kind version
kubectl version --client
kind get clusters
kubectl get nodes
```

# Create Deployment

```bash
kubectl create deployment hotel-service --image=nginx
```

# Verify Resources

```bash
kubectl get deployments
kubectl get replicasets
kubectl get pods
```