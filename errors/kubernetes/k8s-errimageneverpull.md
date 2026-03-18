# Kubernetes ErrImageNeverPull for local images

> Failed to pull image "myapp:latest": rpc error: code = Unknown desc = ErrImageNeverPull

## What happened
Kubernetes refuses to pull an image because `imagePullPolicy: Never` is set, but the image does not exist on the node's local image cache.

## Why it happens
With `imagePullPolicy: Never`, Kubernetes only uses images already present on the node. If the image was built locally with `docker build` but not loaded into the Kubernetes node (minikube, kind, k3s have separate Docker daemons), the image is not found.

## How to fix it
```bash
# For minikube - build directly in minikube's Docker
eval $(minikube docker-env)
docker build -t myapp:latest .

# For kind - load the image into the cluster
docker build -t myapp:latest .
kind load docker-image myapp:latest

# For k3s - import the image
docker save myapp:latest | sudo k3s ctr images import -
```

```yaml
# Pod spec with Never pull policy (for local development)
spec:
  containers:
    - name: app
      image: myapp:latest
      imagePullPolicy: Never  # only use local images
```

## Still not working?
Verify the image is loaded on the correct node with `docker images` (minikube) or `crictl images` (kind/k3s). If using multi-node clusters, the image must be loaded on every node, or switch to `imagePullPolicy: IfNotPresent` and push the image to a local registry. For kind, you can set up a local registry with `kind create cluster --config` including a registry configuration.
