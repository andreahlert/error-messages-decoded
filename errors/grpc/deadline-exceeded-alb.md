# gRPC DeadlineExceeded behind AWS ALB

> rpc error: code = DeadlineExceeded desc = context deadline exceeded

## What happened

Your gRPC calls are failing with `DeadlineExceeded` when routed through an AWS Application Load Balancer (ALB). The same calls work fine when connecting directly to the backend service.

## Why it happens

AWS ALB has a complicated history with gRPC. Before November 2020, ALB didn't support gRPC at all. Even after adding support, ALB requires specific configuration to handle gRPC properly:

- **Target group protocol must be set to "gRPC"** (not HTTP or HTTPS). The default HTTP target group treats gRPC frames as regular HTTP/2, corrupts the framing, and the request silently times out.
- ALB must use HTTP/2 end-to-end. If the target group is configured as HTTP/1.1, gRPC breaks completely because gRPC requires HTTP/2.
- ALB's idle timeout (default 60s) may be shorter than your gRPC deadline. Long-running or streaming RPCs get killed silently.
- Health checks default to HTTP/1.1 GET, which doesn't work for gRPC services that only speak gRPC.

The confusing part: ALB doesn't return a gRPC error. It just drops the connection or times out, so the client sees `DeadlineExceeded` instead of a meaningful error.

## How to fix it

**Option 1: Use NLB instead of ALB (recommended for gRPC):**

NLB operates at Layer 4 (TCP), passes traffic straight through, and doesn't interfere with gRPC/HTTP2 framing:

```hcl
# Terraform: NLB for gRPC
resource "aws_lb" "grpc" {
  name               = "grpc-nlb"
  internal           = false
  load_balancer_type = "network"  # NLB, not application
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "grpc" {
  name        = "grpc-targets"
  port        = 50051
  protocol    = "TCP"  # Raw TCP passthrough
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol = "TCP"
    port     = 50051
  }
}

resource "aws_lb_listener" "grpc" {
  load_balancer_arn = aws_lb.grpc.arn
  port              = 50051
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc.arn
  }
}
```

For TLS termination at the NLB:

```hcl
resource "aws_lb_listener" "grpc_tls" {
  load_balancer_arn = aws_lb.grpc.arn
  port              = 443
  protocol          = "TLS"
  certificate_arn   = var.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc.arn
  }
}
```

**Option 2: Configure ALB correctly for gRPC (if you must use ALB):**

```hcl
resource "aws_lb_target_group" "grpc" {
  name             = "grpc-targets"
  port             = 50051
  protocol         = "HTTP"
  protocol_version = "gRPC"  # THIS IS THE KEY SETTING
  vpc_id           = var.vpc_id
  target_type      = "ip"

  health_check {
    enabled             = true
    path                = "/grpc.health.v1.Health/Check"
    matcher             = "0"  # gRPC status OK
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grpc.arn
  }
}
```

Your gRPC service must implement the health check protocol:

```go
// Go: register gRPC health service
import "google.golang.org/grpc/health/grpc_health_v1"
import "google.golang.org/grpc/health"

healthServer := health.NewServer()
grpc_health_v1.RegisterHealthServer(s, healthServer)
healthServer.SetServingStatus("", grpc_health_v1.HealthCheckResponse_SERVING)
```

**Increase ALB idle timeout for streaming RPCs:**

```hcl
resource "aws_lb" "main" {
  idle_timeout = 300  # 5 minutes, default is 60s
}
```

## Don't do this

- Don't just increase the gRPC deadline timeout on the client. If ALB is silently dropping the connection, no timeout value will fix it.
- Don't use ALB with HTTP/1.1 target groups for gRPC. gRPC requires HTTP/2 and ALB's default HTTP target group mode doesn't guarantee end-to-end HTTP/2.
- Don't ignore the health check configuration. ALB will mark all targets unhealthy if the health check can't reach the gRPC service.

## Still not working?

Debug the connection path:

```bash
# Test gRPC directly to the backend (bypass LB)
grpcurl -plaintext backend-ip:50051 grpc.health.v1.Health/Check

# Test through the ALB
grpcurl -insecure alb-dns:443 grpc.health.v1.Health/Check

# Check ALB access logs for 4xx/5xx
# Enable access logs on the ALB and check the grpc_status_code field
```

If using Kubernetes with AWS Load Balancer Controller:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: grpc-service
  annotations:
    # Use NLB
    service.beta.kubernetes.io/aws-load-balancer-type: "external"
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
spec:
  type: LoadBalancer
  ports:
    - port: 50051
      targetPort: 50051
      protocol: TCP
```

For gRPC-Web (browser clients), you need an Envoy proxy between the browser and your gRPC backend, since browsers don't support native gRPC. ALB alone won't solve this.
