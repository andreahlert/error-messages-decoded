# Terraform state lock is stale

> Error: Error acquiring the state lock. Lock Info: ID: a1b2c3d4-e5f6-7890-abcd-ef1234567890

## What happened
Terraform cannot acquire the state lock because a previous operation left a stale lock behind, preventing any state modifications.

## Why it happens
A previous `terraform apply` or `plan` was interrupted (CI timeout, killed process, network failure) without releasing the lock. The lock entry remains in the backend (DynamoDB table for S3, blob lease for Azure, etc.) and blocks all subsequent operations.

## How to fix it
```bash
# Force-unlock using the lock ID from the error message
terraform force-unlock a1b2c3d4-e5f6-7890-abcd-ef1234567890

# Verify no other terraform process is actually running first
ps aux | grep terraform

# If using S3 backend, check the DynamoDB lock table
aws dynamodb scan --table-name terraform-locks   --filter-expression "LockID = :id"   --expression-attribute-values '{":id":{"S":"terraform-state/prod/terraform.tfstate"}}'
```

## Still not working?
If `force-unlock` fails, manually delete the lock entry from DynamoDB or your backend's lock storage. For S3+DynamoDB, delete the item from the lock table. For Azure, break the blob lease. Always verify that no other Terraform process is running before force-unlocking, to avoid state corruption.
