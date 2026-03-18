# Insufficient cpu / Insufficient memory

> 0/3 nodes are available: 1 Insufficient cpu, 2 Insufficient memory
> Warning  FailedScheduling  default-scheduler  0/5 nodes are available: 5 Insufficient cpu
> pod/myapp-xyz  0/1  Pending  0  15m

## What happened

The Kubernetes scheduler can't find any node with enough free CPU or memory to satisfy your pod's resource requests. The pod stays Pending.

## Why it happens

The scheduler compares your pod's `resources.requests` against each node's allocatable capacity minus what's already requested by other pods. If every node is "full" on paper (even if actual usage is low), the pod can't be scheduled. This is about requested resources, not actual usage.

## How to fix it

```bash
# See what each node has available vs allocated
kubectl describe nodes | grep -A 10 "Allocated resources"

# See actual usage vs requests
kubectl top nodes
kubectl top pods -A --sort-by=cpu

# Find pods that request way more than they use
kubectl top pods -A --sort-by=memory
```

Quick fixes:

```bash
# Lower your requests to match actual usage
resources:
  requests:
    cpu: "50m"       # 0.05 cores, not "500m"
    memory: "64Mi"   # not "512Mi"
  limits:
    cpu: "200m"
    memory: "256Mi"
```

## Don't do this

- Don't remove `requests` entirely. Without requests, your pod gets best-effort QoS and will be the first to be evicted under pressure.
- Don't set requests equal to limits for every pod. That wastes capacity by preventing any bursting.
- Don't scale up nodes without first checking if existing requests are overprovisioned. Most teams request 3-5x what they actually use.

## Still not working?

If you genuinely need more capacity:

```bash
# Scale up your node group (cloud-managed clusters)
# EKS
eksctl scale nodegroup --cluster=mycluster --name=workers --nodes=5

# GKE
gcloud container clusters resize mycluster --node-pool=default-pool --num-nodes=5
```

Enable cluster autoscaler to handle this automatically. Also consider:
- **VPA (Vertical Pod Autoscaler)**: auto-adjusts requests based on actual usage
- **Goldilocks**: shows you recommended requests per pod

Right-sizing requests is more effective than adding nodes. Run `kubectl top pods` during peak hours and set requests to P95 usage.
