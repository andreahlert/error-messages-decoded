# ImagePullBackOff Debugging

**ImagePullBackOff** means Kubernetes failed to pull the container image and is backing off retries. Root causes (in order of likelihood):

## 1. **Image doesn't exist or tag is wrong**
```bash
kubectl describe pod <pod-name> -n <namespace>
```
Look at the `Events` section. You'll see:
- `Error: ErrImagePull` with message like `image not found` or `404`

**Fix:**
```bash
# Verify the image exists
docker pull your-registry/image:tag

# Check the pod's image spec
kubectl get pod <pod-name> -o yaml | grep image:
```

## 2. **Registry authentication failed**
Check events again. You'll see: `Failed to pull image... authentication required`

**Fix - Create a pull secret:**
```bash
kubectl create secret docker-registry my-secret \
  --docker-server=your-registry.com \
  --docker-username=user \
  --docker-password=pass \
  -n <namespace>
```

Then add to pod spec:
```yaml
imagePullSecrets:
  - name: my-secret
```

## 3. **Network/connectivity issue**
Pod node can't reach the registry (firewall, DNS, node network policy).

**Debug from the node:**
```bash
# SSH to the node running the pod
kubectl debug node/<node-name> -it --image=ubuntu

# Inside the debug pod
curl https://your-registry.com
nslookup your-registry.com
```

**Fix:** Configure node network access or use a local registry proxy.

## 4. **Image pulled but not available on this node architecture**
You're pulling a different architecture image (e.g., arm64 on amd64).

**Check:**
```bash
kubectl get pod <pod-name> -o yaml | grep nodeSelector
kubectl get nodes -L kubernetes.io/arch
```

## Quick diagnostic command:
```bash
kubectl describe pod <pod-name> -n <namespace>
```

The `Events` section shows the exact error message. Start there, not with guessing.
