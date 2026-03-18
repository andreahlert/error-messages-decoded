# Kubernetes DNS intermittent resolution failures

> dial tcp: lookup api.external-service.com: i/o timeout

## What happened
DNS resolution inside pods fails intermittently when resolving external domain names, while internal service names work fine.

## Why it happens
Kubernetes configures pods with `ndots:5` in `/etc/resolv.conf` by default. This means any domain with fewer than 5 dots gets appended with search domains first (e.g., `api.external-service.com.default.svc.cluster.local`). This creates 4-5 extra DNS queries per lookup, overloading CoreDNS and causing intermittent timeouts.

## How to fix it
```yaml
# Option 1: Set dnsPolicy and reduce ndots in the pod spec
apiVersion: v1
kind: Pod
spec:
  dnsPolicy: ClusterFirst
  dnsConfig:
    options:
      - name: ndots
        value: "2"
      - name: single-request-reopen

# Option 2: Use FQDN with trailing dot to skip search domains
# In your app config, use "api.external-service.com." (with trailing dot)
```

```bash
# Check current DNS config inside a pod
kubectl exec -it <pod> -- cat /etc/resolv.conf

# Check CoreDNS logs for errors
kubectl logs -n kube-system -l k8s-app=kube-dns
```

## Still not working?
Scale up CoreDNS replicas if the cluster has many pods. Enable CoreDNS caching and check for `SERVFAIL` responses. If using a custom `dnsPolicy`, ensure it falls back to cluster DNS. On AWS EKS, check if the VPC DNS resolver has rate limits. Consider using `NodeLocal DNSCache` for high-traffic clusters.
