# Kubernetes pod has no external internet access

> curl: (7) Failed to connect to api.github.com port 443: Network is unreachable

## What happened
Pods can reach other services inside the cluster but cannot access external internet addresses.

## Why it happens
Outbound traffic from pods requires NAT/masquerading to translate pod IPs to node IPs. If the CNI plugin (Calico, Cilium, Flannel) is misconfigured, iptables NAT rules are missing, or a NetworkPolicy blocks egress traffic, pods cannot reach external services.

## How to fix it
```bash
# Check if a NetworkPolicy is blocking egress
kubectl get networkpolicy -A
kubectl describe networkpolicy -n <namespace>

# Check NAT/masquerade rules on the node
sudo iptables -t nat -L POSTROUTING -n -v

# For Calico, check NAT is enabled
kubectl get installation default -o yaml | grep natOutgoing
# Should be: natOutgoing: Enabled
```

```yaml
# If NetworkPolicy exists, allow egress to external
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-external-egress
spec:
  podSelector: {}
  policyTypes:
    - Egress
  egress:
    - to:
        - ipBlock:
            cidr: 0.0.0.0/0
            except:
              - 10.0.0.0/8
              - 172.16.0.0/12
              - 192.168.0.0/16
```

## Still not working?
Check if the node itself can reach the internet (`curl api.github.com` from the node). Verify the CNI plugin is running on all nodes. For Calico, ensure `ipipMode` or `vxlanMode` is configured correctly. On AWS EKS, verify the subnet has a NAT Gateway and the route table has a route to the internet gateway. Check if IP masquerade agent is running.
