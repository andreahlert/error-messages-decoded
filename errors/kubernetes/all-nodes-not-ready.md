# All nodes NotReady, untolerated taint

> 0/3 nodes are available: 3 node(s) had untolerated taint {node.kubernetes.io/not-ready: }

## What happened

Every node in the cluster is in `NotReady` state. Pods can't be scheduled anywhere. The error message mentions "untolerated taint" but that's misleading. The taint is a symptom, not the cause. Kubernetes automatically taints nodes `node.kubernetes.io/not-ready` when they become NotReady.

## Why it happens

All nodes went NotReady because something fundamental broke at the node level. The scheduler then can't place pods because of the automatic taint. Common root causes:

- **kubelet crashed or stopped** on all nodes
- **Container runtime (containerd/CRI-O) crashed** and kubelet can't report node status
- **CNI plugin (Calico, Flannel, Cilium) is down**, so kubelet reports NotReady due to network not being ready
- **kubelet certificates expired** and nodes can't authenticate to the API server
- **etcd is down** or the control plane lost quorum, so node heartbeats aren't being processed
- **Cloud provider issues**: underlying VMs lost network, metadata service down

## How to fix it

**Step 1: Check node status from kubectl (if API server is reachable):**

```bash
kubectl get nodes -o wide
kubectl describe node <any-node-name> | grep -A5 "Conditions"
```

**Step 2: SSH into a node and check kubelet:**

```bash
ssh user@node-ip

# Check kubelet status
sudo systemctl status kubelet
sudo journalctl -u kubelet --since "10 minutes ago" --no-pager | tail -50
```

**Step 3: Based on what you find:**

If kubelet is crash-looping:

```bash
# Restart kubelet
sudo systemctl restart kubelet
sudo journalctl -u kubelet -f  # watch logs
```

If container runtime is down:

```bash
# Check containerd
sudo systemctl status containerd
sudo journalctl -u containerd --since "10 minutes ago" --no-pager | tail -30

# Restart it
sudo systemctl restart containerd
sudo systemctl restart kubelet
```

If CNI is the problem (kubelet logs show "network plugin is not ready"):

```bash
# Check CNI plugin pods (from a machine with kubectl access)
kubectl get pods -n kube-system | grep -E "calico|flannel|cilium|weave"

# On the node, check CNI config
ls /etc/cni/net.d/
ls /opt/cni/bin/

# If CNI config is missing, redeploy the CNI plugin
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
# or whatever CNI you use
```

If certificates expired:

```bash
# Check kubelet cert expiry
sudo openssl x509 -in /var/lib/kubelet/pki/kubelet-client-current.pem -noout -dates

# On the control plane, check all certs
sudo kubeadm certs check-expiration

# Renew all certs
sudo kubeadm certs renew all
sudo systemctl restart kubelet
```

If etcd is down (control plane issue):

```bash
# On a control plane node
sudo crictl ps | grep etcd
sudo crictl logs $(sudo crictl ps -q --name etcd) --tail 30

# Check etcd health
sudo ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  endpoint health
```

## Don't do this

- Don't add tolerations for `node.kubernetes.io/not-ready` to your pod specs. The nodes are genuinely broken. Scheduling pods on broken nodes doesn't fix anything.
- Don't delete and recreate the nodes before understanding why they went NotReady. The new nodes will likely hit the same issue.
- Don't restart everything blindly. Check kubelet logs first to understand the specific failure.

## Still not working?

If only some system components are reachable, prioritize in this order:

1. etcd (check quorum)
2. kube-apiserver (control plane)
3. kubelet on each node
4. container runtime
5. CNI plugin

For managed Kubernetes (EKS, GKE, AKS), the control plane is managed by the cloud provider. Focus on the worker nodes:

```bash
# EKS: check node group status
aws eks describe-nodegroup --cluster-name mycluster --nodegroup-name mynodegroup

# GKE: check node pool
gcloud container node-pools describe default-pool --cluster mycluster

# Check if the nodes' underlying VMs are running
aws ec2 describe-instance-status --instance-ids i-xxx
```

If nodes were working and suddenly all went NotReady simultaneously, check for infrastructure-level events: cloud provider outage, network partition, or security group changes that blocked kubelet-to-API-server communication (port 6443).
