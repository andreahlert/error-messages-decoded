# Terraform destroy hangs on a resource

> Still destroying... [id=vpc-0abc123, 10m elapsed]

## What happened
`terraform destroy` hangs indefinitely on a resource (often a VPC, security group, or database) without completing.

## Why it happens
The resource has dependencies that Terraform cannot automatically remove: a VPC with running EC2 instances, a security group referenced by another resource, or an RDS instance with deletion protection enabled. AWS will not delete the resource until its dependencies are cleared, and Terraform waits indefinitely.

## How to fix it
```bash
# Destroy specific resources in order using -target
terraform destroy -target=aws_instance.web
terraform destroy -target=aws_security_group.app
terraform destroy -target=aws_vpc.main

# If a resource is stuck and cannot be deleted via API, remove it from state
terraform state rm aws_vpc.main
# Then delete it manually in the AWS console

# For resources with deletion protection
# Disable protection first, then destroy
# lifecycle { prevent_destroy = false }
```

```hcl
# Use depends_on to help Terraform understand destruction order
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  lifecycle {
    create_before_destroy = true
  }
}
```

## Still not working?
Check if the resource has a `lifecycle { prevent_destroy = true }` block. For VPCs, manually delete all ENIs, NAT Gateways, and subnets first. Use `terraform state list` to see all managed resources and destroy dependencies with `-target` before the parent. If Terraform is truly stuck, check the cloud provider console for the resource's actual state.
