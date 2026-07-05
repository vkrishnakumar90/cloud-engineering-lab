# Observations

## Observation 1

Creating a Deployment automatically created:
- ReplicaSet
- Pod
- Container

I never explicitly created these resources.

---

## Observation 2

Deployment does not directly manage Pods.

Deployment creates a ReplicaSet.

ReplicaSet maintains the desired number of Pods.

---

## Observation 3

Pod hierarchy

Application
↓
Container
↓
Pod
↓
ReplicaSet
↓
Deployment

---

## Observation 4

The Control Plane receives kubectl requests and coordinates resource creation.

---

## Observation 5

Pods are ephemeral.

If a Pod is deleted, ReplicaSet creates a new Pod to maintain the desired state.

## Observation 6

Deleted the running Pod manually.

The ReplicaSet immediately detected that the desired Pod count became 0 instead of 1.

ReplicaSet created a completely new Pod.

Observed states:

ContainerCreating

↓

Running

The old Pod was not repaired.

A brand new Pod with a different name was created.

## Observation 7

Experiment:
Deleted the ReplicaSet manually.

Observation:
- Deployment immediately recreated the ReplicaSet.
- The ReplicaSet retained the same generated name because the Deployment template was unchanged.
- A brand new Pod was created with a different name.
- The old Pod was not repaired or reused.

Learning:
Deployment owns ReplicaSets.
ReplicaSets own Pods.
Pods are ephemeral and are replaced rather than repaired.