# Pod OOMKilled (exit code 137)

> State: Terminated
> Reason: OOMKilled
> Exit Code: 137
> Last State: Terminated, Reason: OOMKilled

## What happened

The Linux kernel killed your container because it tried to use more memory than its limit allows. The process gets SIGKILL (signal 9), no graceful shutdown.

## Why it happens

Every container with a `resources.limits.memory` set gets a hard ceiling enforced by the kernel's OOM killer. When the process (plus all its child processes) exceeds that limit, the kernel kills it immediately. This also happens without limits if the node itself runs out of memory.

## How to fix it

```bash
# Check current memory limits
kubectl describe pod myapp-xyz | grep -A 5 "Limits"

# Check actual memory usage before the kill
kubectl top pod myapp-xyz

# Increase the memory limit in your deployment
kubectl patch deployment myapp -p '{"spec":{"template":{"spec":{"containers":[{"name":"myapp","resources":{"limits":{"memory":"512Mi"}}}]}}}}'
```

Or fix it in your YAML:

```yaml
resources:
  requests:
    memory: "256Mi"
  limits:
    memory: "512Mi"
```

## Don't do this

- Don't just keep doubling the memory limit without investigating the actual cause. You might be masking a memory leak.
- Don't remove memory limits entirely in production. One leaky pod will take down the whole node.
- Don't set requests equal to limits unless you want Guaranteed QoS class (which means the pod can never burst).

## Still not working?

Profile your application's memory usage:

```bash
# Java: the JVM doesn't respect container limits by default in older versions
# Add these flags
-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0

# Node.js: V8 default heap is ~1.5GB regardless of container limit
node --max-old-space-size=384 app.js
```

**Trap: JVM `-Xmx` should be ~75% of the container limit, NOT 100%.** The JVM uses memory beyond the heap: thread stacks, metaspace, JIT compiled code, native memory, GC overhead. If your container limit is 512Mi and you set `-Xmx512m`, the JVM total memory will exceed 512Mi and get OOMKilled. Use `-XX:MaxRAMPercentage=75.0` instead of a fixed `-Xmx` so it automatically scales to 75% of the detected container limit.

If memory grows over time (hours/days), that's a memory leak. Check for unclosed connections, event listeners, or growing caches. Use a profiler, not bigger limits.

Check if it's the sidecar, not your app: `kubectl top pod myapp-xyz --containers` shows per-container memory usage.
