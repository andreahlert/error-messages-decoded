# Connection refused to Kubernetes API or services

> dial tcp 10.96.0.1:443: connect: connection refused
> dial tcp 172.20.0.5:8080: connect: connection refused
> Unable to connect to the server: dial tcp <ip>:6443: connect: connection refused

## What happened

A TCP connection to a Kubernetes service or the API server was actively refused. The target port has nothing listening on it.

## Why it happens

Connection refused means the packet reached the host but no process is listening on that port. This is different from a timeout (which means the packet didn't reach the host). Common causes: the target pod crashed, the service selector doesn't match any pods, the target port in the service definition is wrong, or the API server is down.

## How to fix it

```bash
# If it's the API server (port 6443)
kubectl cluster-info
# If this fails, check your kubeconfig
cat ~/.kube/config | grep server

# If it's a service, check it has endpoints
kubectl get endpoints myservice
# Empty ENDPOINTS means no pods match the service selector

# Check if the selector matches
kubectl get svc myservice -o yaml | grep -A 5 selector
kubectl get pods -l app=myapp  # must match the selector

# Check the target port
kubectl get svc myservice -o yaml | grep -A 5 ports
# targetPort must match the port your app actually listens on
```

## Don't do this

- Don't confuse `port` and `targetPort` in the Service definition. `port` is what consumers use, `targetPort` is what your app listens on.
- Don't assume the pod is running just because `kubectl get pods` shows Running. The process inside might have stopped listening.
- Don't add a `readinessProbe` without fixing the underlying issue. The probe will correctly mark it not-ready, but the root cause remains.

## Still not working?

Test connectivity from inside the cluster:

```bash
# Run a debug pod
kubectl run net-debug --rm -it --image=nicolaka/netshoot -- bash

# From inside, test the service
curl -v http://myservice.default.svc.cluster.local:8080
nslookup myservice.default.svc.cluster.local
```

If the API server connection is refused only from certain nodes, check if kube-proxy is running and iptables/ipvs rules are correct:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-proxy
```
