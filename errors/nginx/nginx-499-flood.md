# Nginx 499 Client Closed Request flood

> 499 Client Closed Request

## What happened
Nginx is logging many 499 status codes, meaning clients are closing the connection before Nginx finishes sending the response.

## Why it happens
The upstream server (your application) is responding too slowly. Clients (browsers, load balancers, CDNs) have their own timeout and give up before the response arrives. Nginx logs this as 499, which is a non-standard code meaning "client disconnected." Common causes: slow database queries, blocking I/O in the application, or `proxy_read_timeout` set too low relative to actual response times.

## How to fix it

Increase the proxy timeout if the upstream legitimately needs more time:
```nginx
location / {
    proxy_pass http://backend;
    proxy_read_timeout 120s;    # default is 60s
    proxy_connect_timeout 10s;
    proxy_send_timeout 60s;

    # Enable buffering to free the upstream connection faster
    proxy_buffering on;
    proxy_buffer_size 16k;
    proxy_buffers 8 16k;
}
```

Enable keepalive connections to the upstream to reduce connection overhead:
```nginx
upstream backend {
    server 127.0.0.1:8000;
    keepalive 32;
}

location / {
    proxy_pass http://backend;
    proxy_http_version 1.1;
    proxy_set_header Connection "";
}
```

## Still not working?
- Check if the upstream is actually slow: look at application-level response times, not just Nginx logs.
- If a load balancer sits in front of Nginx, check its idle timeout (AWS ALB default is 60s).
- For long-running requests (file uploads, reports), consider using background jobs and polling instead of keeping the connection open.
- If clients disconnect intentionally (navigating away), 499s are expected and not a problem. Filter them from alerts.
