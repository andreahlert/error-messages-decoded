# Kubernetes ImagePullBackOff despite image existing

> Warning  Failed   kubelet  Back-off pulling image "myregistry.io/app:v2.1.0"

## What happened
Kubernetes cannot pull a container image even though it exists in the registry. The pod enters `ImagePullBackOff` state.

## Why it happens
Common causes: `imagePullPolicy: Always` forces a fresh pull even if the image is cached locally; the image tag was overwritten and the registry requires authentication via `imagePullSecrets` that are missing or expired; the image exists but the node cannot reach the private registry; or the image digest changed but the tag stayed the same.

## How to fix it
```yaml
# Ensure imagePullSecrets are configured
apiVersion: v1
kind: Pod
spec:
  imagePullSecrets:
    - name: registry-credentials
  containers:
    - name: app
      image: myregistry.io/app:v2.1.0
      imagePullPolicy: Always

# Create the secret if missing
# kubectl create secret docker-registry registry-credentials #   --docker-server=myregistry.io #   --docker-username=user #   --docker-password=pass
```

```bash
# Verify the image exists and is accessible
docker pull myregistry.io/app:v2.1.0

# Check if the secret exists in the right namespace
kubectl get secrets -n <namespace>

# Use image digest instead of mutable tags
# image: myregistry.io/app@sha256:abc123...
```

## Still not working?
Check if the node can reach the registry (`kubectl debug node/<node> -- curl https://myregistry.io/v2/`). Verify `imagePullSecrets` is in the correct namespace. If using a service account, check its `imagePullSecrets` field. For local development with minikube/kind, use `imagePullPolicy: IfNotPresent` and load the image directly.
