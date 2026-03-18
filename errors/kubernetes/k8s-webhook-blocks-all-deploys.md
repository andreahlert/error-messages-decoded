# Admission webhook blocks all deployments

> Error from server: error when creating "deployment.yaml": admission webhook "validate.example.com" denied the request

## What happened
A ValidatingWebhookConfiguration or MutatingWebhookConfiguration is rejecting all create/update requests for deployments, preventing any changes to the cluster.

## Why it happens
An admission webhook was configured to intercept resource creation but the webhook server is down, misconfigured, or has overly strict validation rules. If the webhook's `failurePolicy` is set to `Fail` (the default), any webhook server outage blocks all matching API requests.

## How to fix it
```bash
# List all webhooks
kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations

# Inspect the problematic webhook
kubectl get validatingwebhookconfiguration validate.example.com -o yaml

# Option 1: Delete the webhook to unblock deployments
kubectl delete validatingwebhookconfiguration validate.example.com

# Option 2: Patch failurePolicy to Ignore (temporary)
kubectl patch validatingwebhookconfiguration validate.example.com   --type='json' -p='[{"op": "replace", "path": "/webhooks/0/failurePolicy", "value": "Ignore"}]'
```

## Still not working?
Check if the webhook server pod is running and healthy. Verify the webhook's CA bundle is correct and the service endpoint is reachable from the API server. If the webhook is from a Helm chart or operator, check if reinstalling the operator fixes the webhook configuration. Ensure the webhook's `namespaceSelector` or `objectSelector` is not matching too broadly.
