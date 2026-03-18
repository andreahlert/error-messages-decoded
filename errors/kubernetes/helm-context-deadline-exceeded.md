# Helm context deadline exceeded during install/upgrade

> Error: context deadline exceeded

## What happened
A Helm install or upgrade timed out waiting for resources to become ready.

## Why it happens
Helm waits for all resources to reach a ready state within the default timeout (5 minutes). If pods fail to start due to incorrect readiness probes, insufficient resources, image pull delays, or slow startup times, the operation times out.

## How to fix it
```bash
# Increase the Helm timeout
helm upgrade --install myapp ./chart --timeout 10m --wait

# Check what's failing
kubectl get pods -l app=myapp
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

```yaml
# Fix the root cause - common issues in values.yaml:

# Readiness probe too aggressive
readinessProbe:
  initialDelaySeconds: 30  # give the app time to start
  periodSeconds: 10
  failureThreshold: 5

# Startup probe for slow-starting apps
startupProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 30

# Insufficient resources
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
```

## Still not working?
Run `helm upgrade` without `--wait` to skip readiness checking, then debug the pods manually. Check if the pod is stuck in `Pending` (resource constraints), `CrashLoopBackOff` (app crashes), or `ImagePullBackOff` (image issues). Review events with `kubectl get events --sort-by=.metadata.creationTimestamp`.
