# no resolver defined to resolve xxx

> nginx: [emerg] no resolver defined to resolve xxx
> no resolver defined to resolve api.example.com

## What happened

Your nginx config references a hostname (not an IP) in a `proxy_pass` or `upstream` block, and nginx doesn't know how to resolve it to an IP address.

## Why it happens

Nginx doesn't use the system's `/etc/resolv.conf` by default for runtime DNS resolution. When you use a variable in `proxy_pass`, nginx needs to resolve the hostname at request time, and it needs an explicit DNS resolver configured.

Static hostnames in `upstream` blocks are resolved at startup and cached forever, but variable-based hostnames need a resolver.

## How to fix it

**Add a resolver directive:**

```nginx
server {
    resolver 127.0.0.53 valid=30s;  # systemd-resolved
    # or
    resolver 8.8.8.8 valid=30s;     # Google DNS
    # or
    resolver 169.254.169.253 valid=30s;  # AWS VPC DNS

    location /api/ {
        set $backend "api.example.com";
        proxy_pass http://$backend;
    }
}
```

**If you're using a static upstream, just use the IP:**

```nginx
upstream backend {
    server 10.0.1.50:3000;  # use IP instead of hostname
}
```

**In Docker/Kubernetes, use the internal DNS:**

```nginx
resolver 127.0.0.11 valid=10s;  # Docker embedded DNS
# or
resolver kube-dns.kube-system.svc.cluster.local valid=10s;
```

## Don't do this

- Don't use public DNS resolvers (8.8.8.8) for internal service names. They can't resolve your private hostnames.
- Don't set `valid=` to a very high value. If the backend IP changes (common in containers), nginx will keep sending traffic to the old IP.

## Still not working?

- Make sure the resolver is inside the `server` or `http` block, not inside `location`.
- If using Docker, the embedded DNS at `127.0.0.11` only works from within the container network.
- Check `ipv6=off` in the resolver if your network doesn't support IPv6: `resolver 8.8.8.8 ipv6=off;`.
