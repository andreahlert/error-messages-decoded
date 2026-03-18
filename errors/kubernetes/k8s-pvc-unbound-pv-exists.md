# Kubernetes PVC stays unbound despite PV existing

> pod has unbound immediate PersistentVolumeClaims

## What happened
A PersistentVolumeClaim remains in `Pending` state even though a PersistentVolume exists that should satisfy it.

## Why it happens
PVC-to-PV binding requires all of these to match: `storageClassName` must be identical on both PVC and PV (or both empty), `accessModes` must be compatible, PV `capacity` must be >= PVC request, and if the PVC has a `selector`, the PV must have matching labels. A mismatch in any of these prevents binding.

## How to fix it
```bash
# Compare PVC and PV specs
kubectl get pvc my-claim -o yaml
kubectl get pv my-volume -o yaml

# Check storageClassName matches
kubectl get pvc -o custom-columns=NAME:.metadata.name,CLASS:.spec.storageClassName,STATUS:.status.phase
kubectl get pv -o custom-columns=NAME:.metadata.name,CLASS:.spec.storageClassName,STATUS:.status.phase
```

```yaml
# Ensure storageClassName matches on both
# PV
apiVersion: v1
kind: PersistentVolume
spec:
  storageClassName: standard  # must match PVC
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  labels:
    app: myapp  # if PVC uses selector

# PVC
apiVersion: v1
kind: PersistentVolumeClaim
spec:
  storageClassName: standard  # must match PV
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  selector:
    matchLabels:
      app: myapp  # must match PV labels
```

## Still not working?
If `storageClassName` is empty on the PVC, it won't bind to a PV with a class name set (and vice versa). Check if a StorageClass has `volumeBindingMode: WaitForFirstConsumer`, which delays binding until a pod using the PVC is scheduled. Verify the PV is in `Available` state, not `Released` or `Bound`.
