# OOMKilled in Kubernetes: Root Causes & Fixes

## Root Causes

1. **Memory request/limit too low** — Pod is configured with insufficient memory allocation relative to actual workload
2. **Memory leak** — Application gradually consumes more memory over time without releasing it
3. **Spike in traffic/data** — Sudden increase in requests causes memory usage to exceed limits
4. **Unbounded caching** — In-memory cache grows without eviction policy
5. **Large dataset processing** — Loading entire file/dataset into memory instead of streaming
6. **Inefficient algorithm** — O(n²) complexity or similar on large inputs

## How to Fix (Specific Steps)

### 1. **Identify the culprit**
```bash
kubectl logs <pod-name> --previous  # Check logs before crash
kubectl describe pod <pod-name>  # See OOMKilled event
```

### 2. **Check current memory usage**
```bash
kubectl top pod <pod-name>  # Current usage
kubectl get pod <pod-name> -o yaml | grep -A 2 resources  # Current limits
```

### 3. **Increase limits (immediate fix)**
```yaml
resources:
  requests:
    memory: "512Mi"  # Increase this
  limits:
    memory: "1Gi"    # Increase this
```

### 4. **Find the memory leak (permanent fix)**
- **Node.js**: Use `--max-old-space-size` flag, add heap snapshots
- **Java**: Check `-Xmx` setting, look for unclosed connections/streams, use `jmap` for heap analysis
- **Python**: Profile with `memory_profiler`, check for circular references
- **Go**: Use `pprof` profiling

### 5. **Code-level fixes**
- Replace `.readFile()` with streaming for large files
- Implement cache eviction (LRU, TTL)
- Use generators/iterators instead of loading all data upfront
- Close file handles, DB connections explicitly
- Fix any event listener leaks

### 6. **Runtime optimization**
- Set `requests` correctly (triggers pod eviction before hard OOMKill)
- Add `memory.available` node affinity to schedule on less-loaded nodes
- Use horizontal pod autoscaling if traffic-driven

## Quick Check Command
```bash
kubectl get events --field-selector involvedObject.name=<pod-name> --sort-by='.lastTimestamp'
```

What language/framework is your pod running? That'll help narrow down the profiling approach.
