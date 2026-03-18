# Nginx 413 Request Entity Too Large despite config change

> 413 Request Entity Too Large

## What happened
Nginx rejected a request because the body size exceeds `client_max_body_size`, even though you already set it in the configuration.

## Why it happens
Nginx applies `client_max_body_size` at the most specific context level (location > server > http). If you set it in the `http` block but have a `location` block that does not inherit it (or a `proxy_pass` upstream that has its own limit), the default 1MB limit still applies. In Kubernetes with an Ingress controller, the annotation must be set on the Ingress resource, not in a ConfigMap.

## How to fix it

Set `client_max_body_size` at all relevant levels:
```nginx
http {
    client_max_body_size 50M;  # global default

    server {
        listen 80;
        client_max_body_size 50M;  # server level

        location /upload {
            client_max_body_size 100M;  # location level (overrides server)
            proxy_pass http://backend;

            # Also increase proxy buffer settings for large uploads
            proxy_request_buffering off;
        }
    }
}
```

For Kubernetes Nginx Ingress, use the annotation:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "100m"
```

If using a reverse proxy, also check the upstream:
```nginx
location /api {
    proxy_pass http://backend;
    client_max_body_size 100M;

    # Increase timeouts for large uploads
    proxy_read_timeout 300s;
    proxy_send_timeout 300s;
}
```

Test and reload:
```bash
nginx -t && nginx -s reload
```

## Still not working?
- Check if multiple `server` blocks match the request. The wrong server block may be handling it: `curl -v http://host/upload` and check the `Server` header.
- If behind a load balancer (AWS ALB, CloudFlare), check its body size limit too. ALB has a fixed 1MB limit for Lambda targets.
- Verify the right config file is being loaded: `nginx -T | grep client_max_body_size` to see all instances.
- In docker-compose or Kubernetes, ensure the config is actually mounted/applied to the running container.
