# Terraform plan shows changes every run with no config changes

> Terraform plan shows 3 resources to update with no configuration changes

## What happened
`terraform plan` reports resources need updating on every run even though no Terraform configuration was changed.

## Why it happens
Some resources have attributes that change outside of Terraform (timestamps, computed fields, tags applied by AWS auto-tagging) or default values that differ between API responses. AWS `default_tags` propagation, auto-generated IDs, and data sources that return different results each run are common culprits.

## How to fix it
```hcl
# Use lifecycle ignore_changes for attributes managed outside Terraform
resource "aws_instance" "web" {
  ami           = "ami-0123456789"
  instance_type = "t3.micro"

  lifecycle {
    ignore_changes = [
      tags["LastModified"],
      tags["UpdatedBy"],
      # Ignore attributes that drift
    ]
  }
}

# For default_tags drift, pin the provider version
# and use ignore_changes on tags
resource "aws_s3_bucket" "data" {
  bucket = "my-bucket"

  lifecycle {
    ignore_changes = [tags]
  }
}
```

## Still not working?
Run `terraform refresh` then `terraform plan` to sync state with reality. Check if a data source returns different values each run (e.g., `data.aws_ami` finding a newer AMI). Pin data source filters to specific values. If the drift is caused by another system modifying resources, consider importing those changes or using `ignore_changes` for the affected attributes.
