# OOMKilled in Kubernetes: Root Cause & Fix

## Root Cause

OOMKilled happens when a pod exceeds its memory limit. This occurs because:

1. **Memory limit is too low** for the actual workload
2. **Memory leak** in the application (not releasing memory)
3. **Spike in memory usage** (sudden data load, cache buildup)
4. **Misconfigured requests/limits** (no overhead buffer between request and limit)

## How to Fix It

### 1. **Identify the problem** (run these commands)

```bash
# Check the pod event that caused the kill
kubectl describe pod <pod-name> -n <namespace>
# Look for "OOMKilled" in the events section and note the memory limit

# Check actual memory usage before the kill
kubectl top pod <pod-name> -n <namespace>

# Check resource limits
kubectl get pod <pod-name> -n <namespace> -o yaml | grep -A 5 resources
```

### 2. **Fix based on what you find**

**If memory usage is near the limit:**
- Increase the limit in your deployment:
```yaml
resources:
  limits:
    memory: "2Gi"  # Increase this
  requests:
    memory: "1Gi"  # Should be ~50% of limit
```

**If memory keeps growing until it hits the limit:**
- **Code fix needed**: Memory leak. Look for:
  - Objects not being garbage collected
  - Unbounded caches or buffers
  - Event listeners not being removed
  - Circular references
  - Add memory profiling (`pprof` for Go, `heapdump` for Node, etc.)

**If memory spikes suddenly:**
- Add memory buffer: set `limit` ~1.5x the `request`
- Or optimize the spike (e.g., batch processing instead of loading everything at once)

### 3. **Prevent future OOMKills**

```yaml
resources:
  requests:
    memory: "512Mi"    # Minimum guaranteed
  limits:
    memory: "1Gi"      # Hard ceiling (20% buffer above request)
```

Set requests to what you observe + buffer, and limits to 1.5-2x the requests.

---

**TL;DR**: Check `kubectl describe pod` for the limit, then either (1) increase the limit, or (2) find and fix the memory leak if usage grows continuously.
