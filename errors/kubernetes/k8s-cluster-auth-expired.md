# Kubernetes cluster authentication expired

> error: You must be logged in to the server (the server has asked for the client to provide credentials)

## What happened
`kubectl` commands fail with an authentication error because the credentials in your kubeconfig have expired or are no longer valid.

## Why it happens
Cloud-managed Kubernetes clusters (EKS, GKE, AKS) use short-lived tokens for authentication. These tokens expire (typically after 1 hour for EKS, variable for GKE/AKS). If the token refresh mechanism fails or the cloud CLI session has expired, kubectl cannot authenticate.

## How to fix it
```bash
# AWS EKS - refresh credentials
aws eks update-kubeconfig --name my-cluster --region us-east-1
# Or ensure AWS CLI credentials are valid
aws sts get-caller-identity

# GCP GKE - refresh credentials
gcloud container clusters get-credentials my-cluster --zone us-central1-a
# Or re-authenticate
gcloud auth login

# Azure AKS - refresh credentials
az aks get-credentials --resource-group mygroup --name my-cluster
# Or re-authenticate
az login
```

## Still not working?
Check if your cloud CLI session is expired (`aws sts get-caller-identity`, `gcloud auth list`, `az account show`). For EKS, verify the IAM role/user has the correct RBAC bindings in the cluster. If using SSO, re-authenticate with your SSO provider first. Check `~/.kube/config` for the `exec` section to see which command generates the token and test it manually.
