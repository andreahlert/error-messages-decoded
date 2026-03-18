# An error occurred (AccessDenied) when calling the XXX operation

> An error occurred (AccessDenied) when calling the AssumeRole operation: User: arn:aws:iam::123456789012:user/myuser is not authorized to perform: sts:AssumeRole on resource: arn:aws:iam::987654321098:role/MyRole
> An error occurred (AccessDenied) when calling the ListBuckets operation: Access Denied

## What happened

Your IAM user or role doesn't have permission to perform the AWS API call you tried. AWS rejected the request because the policy attached to your identity doesn't include the required action.

## Why it happens

- Your IAM user/role is missing the required policy
- An explicit Deny in an SCP, permission boundary, or resource policy overrides the Allow
- You're using the wrong AWS profile or account
- The resource policy (e.g., S3 bucket policy) doesn't allow your identity

## How to fix it

**Check which identity you're using:**

```bash
aws sts get-caller-identity
```

Make sure the account and ARN match what you expect.

**Check if the right profile is active:**

```bash
# List profiles
aws configure list-profiles

# Use the right one
export AWS_PROFILE=my-work-profile
aws sts get-caller-identity
```

**Add the required permission to your IAM policy:**

```json
{
  "Effect": "Allow",
  "Action": "s3:ListBucket",
  "Resource": "arn:aws:s3:::my-bucket"
}
```

**For AssumeRole, the trust policy on the target role must allow your identity:**

```json
{
  "Effect": "Allow",
  "Principal": {
    "AWS": "arn:aws:iam::123456789012:user/myuser"
  },
  "Action": "sts:AssumeRole"
}
```

## Don't do this

- Don't attach `AdministratorAccess` just to get it working. Find the specific permission needed.
- Don't use root account credentials. Ever.

## Still not working?

- Use IAM Policy Simulator to test: `aws iam simulate-principal-policy`.
- Check SCPs (Service Control Policies) if you're in an AWS Organization. They override everything.
- Check permission boundaries on the role. They limit the maximum permissions a role can have.
- Enable CloudTrail and look at the exact `errorCode` and `errorMessage` for the denied call.
