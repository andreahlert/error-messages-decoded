# CreateContainerConfigError

> Warning  Failed  pod/myapp-xyz  Error: CreateContainerConfigError
> Error: secret "myapp-secret" not found
> Error: configmap "myapp-config" not found

## What happened

Kubernetes accepted the pod spec but can't create the container because a referenced ConfigMap, Secret, or ServiceAccount doesn't exist.

## Why it happens

Your pod spec references a ConfigMap or Secret (via `envFrom`, `env.valueFrom`, or volume mounts) that hasn't been created in the namespace yet. Kubernetes can't configure the container environment, so it refuses to start. Unlike ImagePullBackOff, this fails before even pulling the image.

## How to fix it

```bash
# Check the exact error
kubectl describe pod myapp-xyz | grep -A 5 "Warning"

# List what exists in the namespace
kubectl get configmaps
kubectl get secrets
kubectl get serviceaccounts

# Create the missing resource
kubectl create configmap myapp-config --from-file=config.yaml
kubectl create secret generic myapp-secret --from-literal=DB_PASSWORD=changeme
```

If the resources exist in a different namespace, that's the problem. ConfigMaps and Secrets are namespace-scoped:

```bash
# Check which namespace you're in
kubectl config get-contexts
kubectl get configmap myapp-config -n correct-namespace
```

## Don't do this

- Don't mark the ConfigMap/Secret as `optional: true` just to get the pod running. Your app will start with missing config and probably crash anyway.
- Don't copy secrets between namespaces manually. Use tools like `kubed` or external secret operators.

## Still not working?

If the ConfigMap/Secret exists but a specific key is missing:

```bash
# Check available keys
kubectl get configmap myapp-config -o yaml
kubectl get secret myapp-secret -o yaml

# The pod might reference a key that doesn't exist:
# env:
#   - name: DB_HOST
#     valueFrom:
#       configMapKeyRef:
#         name: myapp-config
#         key: database_host  # <-- this key must exist
```

If you deployed with Helm, you might need to install/upgrade the chart. Helm templates often generate the ConfigMaps and Secrets alongside the Deployment.
