# Node NotReady

> NAME          STATUS     ROLES    AGE   VERSION
> worker-1      NotReady   <none>   30d   v1.28.2
> Warning  NodeNotReady  pod/myapp-xyz  Node is not ready

## What happened

One or more nodes in your cluster stopped reporting as healthy. Pods on that node may be evicted or stuck in Unknown state.

## Why it happens

The kubelet on the node stopped communicating with the API server. Common causes: the node ran out of disk, memory, or PIDs, the kubelet process crashed, the container runtime (containerd/Docker) is unresponsive, or there's a network partition between the node and the control plane.

## How to fix it

```bash
# Check node conditions
kubectl describe node worker-1 | grep -A 20 "Conditions"

# Look for DiskPressure, MemoryPressure, PIDPressure
# If any are True, that's your cause

# SSH into the node and check kubelet
sudo systemctl status kubelet
sudo journalctl -u kubelet --no-pager -n 100

# Check disk space
df -h

# Check container runtime
sudo systemctl status containerd
sudo crictl ps
```

## Don't do this

- Don't immediately drain and delete the node. Diagnose first, the problem might follow you to the replacement.
- Don't ignore NotReady nodes "because the app still works." When another node goes down, you have zero headroom.
- Don't restart kubelet as the first action. Check the logs first to understand why it's unhealthy.

## Still not working?

If kubelet logs show certificate errors, the node's certificate may have expired:

```bash
sudo openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem -noout -dates
```

If the node is truly dead (hardware failure, cloud instance terminated), remove it:

```bash
kubectl drain worker-1 --ignore-daemonsets --delete-emptydir-data --force
kubectl delete node worker-1
```

On managed Kubernetes (EKS/GKE/AKS), the cloud provider should auto-replace unhealthy nodes. If it doesn't, check your node group health check settings.
