# Error from server (Forbidden): cannot create resource

> Error from server (Forbidden): deployments.apps is forbidden: User "system:serviceaccount:default:myapp" cannot create resource "deployments" in API group "apps" in the namespace "production"
> Error from server (Forbidden): pods is forbidden: User "developer@company.com" cannot list resource "pods" in API group "" in the namespace "kube-system"

## What happened

Your user or service account doesn't have RBAC permissions to perform the requested action. Kubernetes denied the API call.

## Why it happens

Kubernetes RBAC requires explicit permission grants. If no Role/ClusterRole + RoleBinding/ClusterRoleBinding grants the action, it's denied by default. This commonly happens with new service accounts, users switching namespaces, or CI/CD pipelines that were set up with minimal permissions.

## How to fix it

```bash
# Check what permissions you currently have
kubectl auth can-i create deployments
kubectl auth can-i create deployments --as system:serviceaccount:default:myapp

# Check existing roles and bindings
kubectl get rolebindings,clusterrolebindings -A | grep myapp

# Create a Role with the needed permissions
kubectl create role deploy-manager --verb=create,get,list,update --resource=deployments -n production

# Bind it to the service account
kubectl create rolebinding deploy-manager-binding --role=deploy-manager --serviceaccount=default:myapp -n production
```

## Don't do this

- Don't bind `cluster-admin` to fix permission issues. That's the Kubernetes equivalent of `chmod 777`.
- Don't create ClusterRoleBindings when a namespaced RoleBinding would suffice. Least privilege matters.
- Don't give service accounts permissions they don't need "just in case."

## Still not working?

The error message tells you exactly what's missing. Parse it:
- **User**: who is making the request
- **Verb**: what action (create, list, get, delete, update, patch)
- **Resource**: what resource type
- **Namespace**: where

```bash
# Debug RBAC decisions
kubectl auth can-i --list --as system:serviceaccount:default:myapp -n production
```

If using a cloud provider's IAM integration (EKS IAM, GKE Workload Identity), the mapping between cloud IAM and Kubernetes RBAC might be broken. Check `aws-auth` ConfigMap on EKS or the IAM policy on GKE.
