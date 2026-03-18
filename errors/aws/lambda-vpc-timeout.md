# AWS Lambda VPC timeout

> Task timed out after 15.00 seconds

## What happened
An AWS Lambda function timed out because it could not reach an external service or the internet from within a VPC.

## Why it happens
When a Lambda function is attached to a VPC, it runs inside a private subnet and loses internet access by default. The function cannot reach external APIs, AWS services (S3, DynamoDB, SQS), or the internet. This also involves cold start latency because Lambda needs to create an ENI (Elastic Network Interface) in your VPC subnet, which can take several seconds.

## How to fix it

For internet access, route traffic through a NAT Gateway:
```bash
# 1. Create a NAT Gateway in a public subnet
aws ec2 create-nat-gateway \
  --subnet-id subnet-public-123 \
  --allocation-id eipalloc-xxx

# 2. Add a route in the private subnet's route table
aws ec2 create-route \
  --route-table-id rtb-private-456 \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id nat-xxx
```

For AWS services, use VPC Endpoints (no NAT needed, lower cost):
```bash
# Gateway endpoint for S3
aws ec2 create-vpc-endpoint \
  --vpc-id vpc-xxx \
  --service-name com.amazonaws.us-east-1.s3 \
  --route-table-ids rtb-private-456

# Interface endpoint for other services (SQS, Secrets Manager, etc.)
aws ec2 create-vpc-endpoint \
  --vpc-id vpc-xxx \
  --service-name com.amazonaws.us-east-1.sqs \
  --subnet-ids subnet-private-789 \
  --security-group-ids sg-xxx
```

Check the security group allows outbound traffic:
```bash
aws ec2 describe-security-groups --group-ids sg-xxx \
  --query 'SecurityGroups[0].IpPermissionsEgress'
```

## Still not working?
- Verify the Lambda function's subnet is private (not public). Lambda ignores public IPs even in public subnets.
- Check that the subnet has available IP addresses: Lambda needs one ENI per concurrent execution.
- If you do not need VPC access (no RDS, ElastiCache, etc.), remove the VPC configuration entirely to avoid these issues.
- Cold starts with VPC can add 5-10 seconds. Use provisioned concurrency for latency-sensitive functions.
