# Pod stuck in CrashLoopBackOff

> Warning  BackOff  pod/myapp-xyz  Back-off restarting failed container
> myapp-xyz  0/1  CrashLoopBackOff  5  3m

## What happened

Your container starts, crashes, and Kubernetes keeps restarting it with exponentially increasing delays. The pod never becomes Ready.

## Why it happens

The process inside the container exits with a non-zero code. Kubernetes sees the crash, restarts the container, it crashes again, and the backoff timer grows (10s, 20s, 40s... up to 5 minutes). The root cause is inside the container: missing config, failed DB connection, segfault, wrong command, whatever makes the process die.

## How to fix it

```bash
# Check why it's crashing - this is the most important step
kubectl logs myapp-xyz
kubectl logs myapp-xyz --previous  # logs from the LAST crash

# Check events for more context
kubectl describe pod myapp-xyz

# If logs are empty, run the container interactively
kubectl run debug --rm -it --image=myimage -- /bin/sh
```

The logs will tell you the real cause. Common ones:
- Missing environment variable or config file: fix your ConfigMap/Secret
- Database connection refused: check the service name and network policy
- File not found: check your Dockerfile ENTRYPOINT/CMD

## Don't do this

- Don't just delete the pod. The Deployment will create a new one that crashes the same way.
- Don't increase `restartPolicy` backoff thinking it needs "more time to start." The container is crashing, not slow-starting.
- Don't set `restartPolicy: Never` on a Deployment. That's only for Jobs.

## Still not working?

If `kubectl logs` shows nothing, the container might be crashing before stdout is flushed:

```bash
# Check the exit code
kubectl get pod myapp-xyz -o jsonpath='{.status.containerStatuses[0].lastState.terminated.exitCode}'

# Exit code 137 = OOMKilled (see oomkilled.md)
# Exit code 1 = application error
# Exit code 126 = permission denied on entrypoint
# Exit code 127 = entrypoint not found
```

Add a `command: ["sleep", "3600"]` override temporarily to keep the pod alive so you can exec in and debug.
