# 403 Forbidden when accessing S3

> An error occurred (403) when calling the HeadObject operation: Forbidden
> <Error><Code>AccessDenied</Code><Message>Access Denied</Message></Error>
> fatal error: An error occurred (403) when calling the HeadBucket operation: Forbidden

## What happened

Your request to S3 was denied. This can be an IAM issue, a bucket policy issue, an ACL issue, or several other things. S3 access is notoriously confusing because permissions come from multiple layers.

## Why it happens

S3 evaluates permissions from multiple sources, and ALL must allow the request:

1. IAM policy on the user/role
2. Bucket policy
3. S3 Block Public Access settings
4. Object ACLs (legacy)
5. VPC endpoint policy (if using VPC endpoints)

## How to fix it

**Check your identity and basic access:**

```bash
aws sts get-caller-identity
aws s3 ls s3://my-bucket/ --debug 2>&1 | head -50
```

**Ensure your IAM policy allows the action:**

```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:ListBucket"],
  "Resource": [
    "arn:aws:s3:::my-bucket",
    "arn:aws:s3:::my-bucket/*"
  ]
}
```

Note: `s3:ListBucket` applies to the bucket ARN (no `/*`), while `s3:GetObject` applies to objects (with `/*`). Getting this wrong is the #1 cause of 403s.

**Check the bucket policy:**

```bash
aws s3api get-bucket-policy --bucket my-bucket | jq '.Policy | fromjson'
```

**Check Block Public Access (this is the trap):**

```bash
aws s3api get-public-access-block --bucket my-bucket
```

**Trap: S3 Block Public Access overrides everything.** Even if your bucket policy explicitly grants public access, Block Public Access (enabled by default since April 2023) silently blocks it. This also applies at the AWS account level. You can have a perfect bucket policy and still get 403s because of account-level Block Public Access settings:

```bash
# Check account-level settings (often the hidden culprit)
aws s3control get-public-access-block --account-id $(aws sts get-caller-identity --query Account --output text)

# Check bucket-level settings
aws s3api get-public-access-block --bucket my-bucket
```

Both must allow public access if your bucket policy grants it. This catches people who copy bucket policies from pre-2023 tutorials.

## Don't do this

- Don't make the bucket public to fix a 403. That exposes everything to the internet.
- Don't add `s3:*` on resource `*`. Give the minimum permissions needed.
- Don't confuse bucket-level and object-level permissions. `ListBucket` needs the bucket ARN, `GetObject` needs `bucket/*`.

## Still not working?

- If the bucket is in another account, the bucket policy must explicitly grant your account access AND your IAM policy must allow the action. Both are required.
- If using a VPC endpoint, check the VPC endpoint policy. It can deny access even if IAM and bucket policy allow it.
- Check if server-side encryption (SSE-KMS) is enabled. You need `kms:Decrypt` permission on the KMS key.
- Use `aws s3api head-object --bucket my-bucket --key my-key` to get the specific error for a single object.
