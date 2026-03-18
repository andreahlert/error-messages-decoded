# Kubernetes Ingress returns 404 but port-forward works

> default backend - 404

## What happened
Accessing a service via Ingress returns a 404 "default backend" error, but `kubectl port-forward` to the same service works fine.

## Why it happens
The Ingress controller is not matching your Ingress rules to the request. Common causes: missing `ingressClassName` (so the controller ignores the Ingress), incorrect `pathType` (Exact vs Prefix), wrong path matching, or the Ingress class annotation is wrong for your controller.

## How to fix it
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp
  annotations:
    # For nginx ingress controller, may need rewrite
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx  # REQUIRED - must match your controller
  rules:
    - host: myapp.example.com
      http:
        paths:
          - path: /
            pathType: Prefix  # Use Prefix for catch-all, Exact for specific paths
            backend:
              service:
                name: myapp-service
                port:
                  number: 80
```

```bash
# Check which ingress class is available
kubectl get ingressclass

# Verify the ingress controller sees your ingress
kubectl get ingress myapp

# Check controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx
```

## Still not working?
Verify the service port matches the ingress backend port. Check if the host header in your request matches the `host` rule. If using path-based routing, ensure `pathType: Prefix` is set (not `ImplementationSpecific`). Use `kubectl describe ingress myapp` to see if the controller has assigned an address and check for warnings.
