# ImagePullBackOff / ErrImagePull

> Failed to pull image "myapp:latest": rpc error: code = Unknown desc = Error response from daemon: pull access denied
> Warning  Failed  pod/myapp-xyz  Error: ImagePullBackOff
> Warning  Failed  pod/myapp-xyz  Error: ErrImagePull

## What happened

Kubernetes can't pull the container image. The node tried, failed, and is now backing off before retrying.

## Why it happens

The image name or tag is wrong, the image doesn't exist in the registry, or the node doesn't have credentials to pull from a private registry. `ErrImagePull` is the first failure, `ImagePullBackOff` is Kubernetes slowing down retries.

## How to fix it

```bash
# Check the exact error message
kubectl describe pod myapp-xyz | grep -A 5 "Events"

# Verify the image exists (from your machine)
docker pull myregistry.io/myapp:v1.2.3

# For private registries, create an image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=ghcr.io \
  --docker-username=your-user \
  --docker-password=your-token

# Reference it in the pod spec
# spec.imagePullSecrets:
#   - name: regcred
```

Check common mistakes:

```bash
# Wrong: missing registry prefix
image: myapp:latest

# Right: full registry path
image: ghcr.io/org/myapp:v1.2.3
```

## Don't do this

- Don't use `:latest` tag in production. If the tag was overwritten with a different architecture or broken build, you'll get a different kind of failure.
- Don't store registry credentials in plain YAML files in your repo. Use sealed secrets or external secret operators.

## Still not working?

If the image exists and credentials are correct, check if the node can reach the registry:

```bash
# SSH into the node or run a debug pod
kubectl run net-debug --rm -it --image=busybox -- wget -qO- https://ghcr.io/v2/
```

For AWS ECR, tokens expire every 12 hours. Use the ECR credential helper or a CronJob to refresh:

```bash
# Refresh ECR token
aws ecr get-login-password | kubectl create secret docker-registry ecr-cred \
  --docker-server=<account>.dkr.ecr.<region>.amazonaws.com \
  --docker-username=AWS --docker-password-stdin --dry-run=client -o yaml | kubectl apply -f -
```
