# CrashLoopBackOff with No Logs: Root Causes & Fixes

The app is crashing before logs become visible. Here's the diagnosis workflow:

## Step 1: Verify You're Checking Logs Correctly

```bash
# Get current logs (might be empty if crash is immediate)
kubectl logs <pod-name>

# Get PREVIOUS container logs (before it restarted)
kubectl logs <pod-name> --previous

# Watch live logs with timestamps
kubectl logs <pod-name> -f --timestamps=true
```

**The `--previous` flag is crucial** — it shows logs from the last completed container run before the crash.

## Step 2: Diagnose the Real Problem

```bash
# Get detailed pod status and events
kubectl describe pod <pod-name>
```

Look in the **Events** section. The actual cause is usually here:
- `ImagePullBackOff` — can't pull image (typo in image name, auth issue, image doesn't exist)
- `CrashLoopBackOff` with message about `OOMKilled` — out of memory
- `CreateContainerConfigError` — missing ConfigMap/Secret or bad environment
- `Init Container` failed — init container crashed before app started

## Step 3: Check What's Actually Killing the Process

```bash
# See exit code and reason
kubectl describe pod <pod-name> | grep -A 5 "Last State"

# Get detailed container status
kubectl get pod <pod-name> -o json | jq '.status.containerStatuses[0]'
```

Exit codes tell you:
- **Exit code 1** — application error (bad startup, missing dependency)
- **Exit code 137** — OOMKilled (not enough memory)
- **Exit code 139** — segmentation fault
- **Exit code 126** — permission denied

## Step 4: Common Fixes

### A) Application Crashes Immediately (No Logs Yet)
The app dies before writing logs. Fix:
```dockerfile
# Ensure logs go to stdout, not files
CMD ["app", "--log-to-stdout"]
# Or redirect
CMD ["sh", "-c", "app 2>&1"]
```

### B) Missing ConfigMap/Secret
```bash
# Check if ConfigMap exists
kubectl get configmap <name> -n <namespace>

# Check if Secret exists  
kubectl get secret <name> -n <namespace>
```

### C) Out of Memory
```bash
# Check current resource requests/limits
kubectl describe pod <pod-name> | grep -A 5 "Limits\|Requests"

# Increase memory limit in deployment
kubectl set resources deployment <name> --limits=memory=1Gi
```

### D) Image Won't Pull
```bash
# Verify image exists and is accessible
docker pull <image-name>:<tag>

# Check image pull secret if using private registry
kubectl get secrets -n <namespace> | grep docker
```

## Step 5: Debug Shell Access

```bash
# If the container keeps crashing, override the startup command
kubectl run -it --image=<image> debug-pod -- sh

# Or use a debugging sidecar temporarily
```

**TL;DR**: Run `kubectl describe pod <name>` and `kubectl logs <name> --previous`. The answer is almost always in those two commands.
