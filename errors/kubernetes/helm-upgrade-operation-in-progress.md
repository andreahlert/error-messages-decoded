# Helm upgrade fails with operation in progress

> Error: UPGRADE FAILED: another operation (install/upgrade/rollback) is in progress

## What happened
A Helm release is stuck in a pending state from a previous failed operation, blocking new upgrades.

## Why it happens
A previous `helm install`, `upgrade`, or `rollback` was interrupted (timeout, killed process, CI failure) and left the release in `pending-install`, `pending-upgrade`, or `pending-rollback` state. Helm refuses to perform new operations while a previous one appears to be running.

## How to fix it
```bash
# Check release history
helm history myapp

# Roll back to the last successful revision
helm rollback myapp <last-good-revision>

# If rollback also fails, force it
helm rollback myapp <last-good-revision> --force

# If the release is in pending-install (never succeeded),
# delete the release secret and reinstall
kubectl delete secret sh.helm.release.v1.myapp.v1
helm install myapp ./chart
```

```bash
# If all else fails, manually fix the release secret
# List Helm release secrets
kubectl get secrets -l owner=helm,name=myapp

# Delete the pending release secret
kubectl delete secret sh.helm.release.v1.myapp.v<broken-version>
```

## Still not working?
Check `helm history myapp` for the exact status. If the release has no successful revisions, delete all its release secrets (`kubectl delete secret -l owner=helm,name=myapp`) and do a fresh install. The release state is stored in Kubernetes secrets (or configmaps), so deleting the specific pending-state secret can unblock operations.
