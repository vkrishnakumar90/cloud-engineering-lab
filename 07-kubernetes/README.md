# Kubernetes Lab 01 - Kind Cluster & First Deployment

## Objective

- Create a local Kubernetes cluster using Kind.
- Verify the cluster using kubectl.
- Deploy the first application.
- Understand the relationship between Deployment, ReplicaSet and Pod.

## Architecture

Deployment
    ↓
ReplicaSet
    ↓
Pod
    ↓
Container
    ↓
Application

## Key Learnings

- Kubernetes works on the Desired State principle.
- Deployment manages releases.
- ReplicaSet maintains the desired number of Pods.
- Pod is the smallest deployable unit.
- Containers run inside Pods.