# Terraform state has resource that no longer exists in cloud

> Terraform state contains aws_instance.web but the EC2 instance does not exist in AWS console

## What happened
Terraform's state file references a resource that was deleted outside of Terraform (manually in the console, by another tool, or by AWS).

## Why it happens
Someone deleted the resource directly in the cloud console or via CLI without using `terraform destroy`. Terraform's state still tracks the resource, but it no longer exists. On the next `plan`/`apply`, Terraform may error out or try to recreate it unexpectedly.

## How to fix it
```bash
# Remove the orphaned resource from state
terraform state rm aws_instance.web

# This tells Terraform to stop managing the resource
# It does NOT delete anything - the resource is already gone

# Then run plan to verify clean state
terraform plan
```

```bash
# If you want to import an existing replacement resource into state
terraform import aws_instance.web i-0abc123def456

# Or use terraform refresh to sync state with actual cloud resources
terraform refresh
```

## Still not working?
Use `terraform state list` to find the exact resource address. If the resource is in a module, include the module path: `terraform state rm module.mymodule.aws_instance.web`. Run `terraform refresh` to sync state with reality before making changes. For data sources that reference the deleted resource, update the configuration to remove the dependency.
