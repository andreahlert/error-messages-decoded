# kubectl x509 certificate signed by unknown authority

> Unable to connect to the server: x509: certificate signed by unknown authority

## What happened
`kubectl` cannot connect to the Kubernetes API server because it does not trust the server's TLS certificate.

## Why it happens
The kubeconfig file references a cluster CA certificate that is missing, expired, or does not match the server's actual certificate. This happens after cluster certificate rotation, when using a kubeconfig from a different machine, or when the cluster CA was regenerated. Corporate proxies performing TLS inspection can also cause this.

## How to fix it
```bash
# Refresh kubeconfig from your cloud provider
# AWS EKS
aws eks update-kubeconfig --name my-cluster --region us-east-1

# GCP GKE
gcloud container clusters get-credentials my-cluster --zone us-central1-a

# Azure AKS
az aks get-credentials --resource-group mygroup --name my-cluster

# Check current kubeconfig
kubectl config view
cat ~/.kube/config | grep certificate-authority
```

```bash
# If self-managed cluster, update the CA certificate
# Copy the cluster CA to your machine
scp master:/etc/kubernetes/pki/ca.crt ~/.kube/cluster-ca.crt

# Update kubeconfig to point to it
kubectl config set-cluster my-cluster   --certificate-authority=$HOME/.kube/cluster-ca.crt   --server=https://api.my-cluster:6443
```

## Still not working?
Check if `KUBECONFIG` environment variable points to the correct file. If behind a corporate proxy, the proxy's CA certificate needs to be added to your system trust store. Verify the API server URL in kubeconfig matches the actual server address. Check certificate expiry with `openssl s_client -connect api-server:6443`.
