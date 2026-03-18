# Pod Evicted

> Status: Failed
> Reason: Evicted
> Message: The node was low on resource: ephemeral-storage
> Message: The node was low on resource: memory

## What happened

Kubernetes forcefully removed your pod from a node because the node was running out of a critical resource. The pod is terminated and won't be restarted on the same node.

## Why it happens

The kubelet monitors node resources (memory, disk, PIDs) and has eviction thresholds. When a resource drops below the threshold (e.g., less than 100Mi memory available), kubelet starts killing pods to protect the node. Pods with no resource requests or BestEffort QoS get evicted first, followed by pods exceeding their requests.

## How to fix it

```bash
# Check why it was evicted
kubectl describe pod myapp-xyz | grep -A 5 "Status\|Reason\|Message"

# Check node conditions
kubectl describe node <node-name> | grep -A 5 "Conditions"

# Clean up evicted pods (they linger in Failed state)
kubectl get pods --field-selector=status.phase=Failed -A
kubectl delete pods --field-selector=status.phase=Failed -A
```

For ephemeral-storage evictions:

```bash
# Set storage requests/limits
resources:
  requests:
    ephemeral-storage: "1Gi"
  limits:
    ephemeral-storage: "2Gi"

# Common culprit: app writing large log files to the container filesystem
# Fix: write logs to stdout, not files
```

For memory evictions, set proper memory requests so your pod gets Burstable or Guaranteed QoS.

## Don't do this

- Don't ignore evicted pods piling up. They indicate a systemic resource problem on your nodes.
- Don't run stateful workloads without resource requests. They'll be first to get evicted.
- Don't write temp files or logs to the container's writable layer. Use emptyDir volumes with size limits instead.

## Still not working?

Adjust kubelet eviction thresholds (not recommended for production without careful testing):

```yaml
# kubelet config
evictionHard:
  memory.available: "200Mi"
  nodefs.available: "10%"
  imagefs.available: "15%"
```

If pods keep getting evicted across all nodes, you need bigger nodes or fewer pods. Use `kubectl top nodes` to see actual resource usage and consider adding a node pool with more memory/storage.
