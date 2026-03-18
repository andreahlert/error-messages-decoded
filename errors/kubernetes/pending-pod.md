# Pod stuck in Pending state

> myapp-xyz  0/1  Pending  0  10m
> Warning  FailedScheduling  0/3 nodes are available: 3 Insufficient memory
> Warning  FailedScheduling  no nodes available to schedule pods

## What happened

The pod was created but Kubernetes can't find a node to run it on. It sits in Pending indefinitely until resources become available.

## Why it happens

The scheduler can't place the pod because: no node has enough CPU/memory to satisfy the pod's resource requests, node selectors or affinity rules exclude all nodes, taints on nodes repel the pod, or PersistentVolumeClaims can't be bound.

## How to fix it

```bash
# FIRST: check why it's pending
kubectl describe pod myapp-xyz | grep -A 20 "Events"

# Check node resources
kubectl describe nodes | grep -A 5 "Allocated resources"
kubectl top nodes

# If resources are the issue, lower your requests
resources:
  requests:
    cpu: "100m"      # was "500m"
    memory: "128Mi"  # was "512Mi"
```

If it's a scheduling constraint issue:

```bash
# Check node labels
kubectl get nodes --show-labels

# Check taints
kubectl describe node <node-name> | grep Taints

# Add a toleration if needed
tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "gpu"
    effect: "NoSchedule"
```

## Don't do this

- Don't set `requests` higher than what your app actually needs. Over-requesting is the #1 cause of unschedulable pods.
- Don't confuse `requests` with `limits`. Requests are what the scheduler uses to place pods. Limits are the ceiling.

## Still not working?

**Trap: PersistentVolumeClaim (PVC) binding issues.** A pod that mounts a PVC will stay Pending forever if the PVC can't bind. `kubectl describe pod` may just say "unschedulable" without clearly pointing to the PVC. Always check PVCs separately:

```bash
kubectl get pvc
# If status is "Pending", THAT is why your pod is stuck
kubectl describe pvc my-pvc
```

Common PVC binding failures:
- No PersistentVolume matches the PVC's `storageClassName`, size, or access mode
- The PV exists but is `Bound` to a different PVC (PVs are one-to-one)
- The storage class provisioner is broken or misconfigured (check `kubectl get sc`)
- Using `ReadWriteOnce` PV and the pod is scheduled on a different node than where the volume is attached (common with EBS)

If you're using a cluster autoscaler, the pod should trigger a scale-up. Check autoscaler logs:

```bash
kubectl logs -n kube-system -l app=cluster-autoscaler
```

On EKS/GKE/AKS, check your node pool's max size. You might have hit the ceiling.
