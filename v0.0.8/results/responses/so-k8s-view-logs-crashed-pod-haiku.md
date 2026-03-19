# Root Cause

When you try to view logs from a crashed pod using `kubectl logs <pod-name>`, you're hitting one of these scenarios:

1. **Default logs target the current container** - `kubectl logs` tries to get logs from the running container, but the pod crashed, so there's no running container
2. **Previous container logs are inaccessible** - If the pod restarted (you see `RESTARTS > 0` in `kubectl get pods`), the crashed container's logs are in a previous instance
3. **Container crashed before logging** - The container exited so quickly that it didn't generate any logs

# The Fix

Use the **`--previous` flag** to access logs from the crashed (previous) container:

```bash
kubectl logs <pod-name> --previous
# or shorter:
kubectl logs <pod-name> -p
```

If the pod has multiple containers:
```bash
kubectl logs <pod-name> -c <container-name> --previous
```

# If Previous Logs Are Empty or Unavailable

Check the **pod events and status** for the actual error:
```bash
kubectl describe pod <pod-name>
```

Look for:
- **Events** section at the bottom (shows what happened during the crash)
- **Last State** section under containers (shows exit code and message)
- **Reason** field (common values: `Error`, `CrashLoopBackOff`, `OOMKilled`, `Evicted`)

# Example Workflow

```bash
# 1. See pod status and restart count
kubectl get pods -o wide | grep <pod-name>

# 2. Get logs from crashed container
kubectl logs <pod-name> --previous

# 3. Get detailed info (often shows the actual error)
kubectl describe pod <pod-name>

# 4. Check logs with limiting (useful for large logs)
kubectl logs <pod-name> --previous --tail=100
```

The **`describe` output** is usually where you'll find the root cause if logs are empty.
