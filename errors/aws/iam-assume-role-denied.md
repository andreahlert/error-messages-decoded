# IAM assume role denied - not authorized to perform sts:AssumeRole

> User: arn:aws:iam::123:user/deploy is not authorized to perform: sts:AssumeRole

## What happened
An IAM user or role tried to assume another IAM role but was denied by AWS STS.

## Why it happens
Assuming a role requires two things to be in place: (1) the calling principal must have permission to call `sts:AssumeRole`, and (2) the target role's trust policy must explicitly allow the calling principal. This error means one or both of these are missing. It can also fail if the trust policy has a `Condition` (like `sts:ExternalId`) that is not satisfied.

## How to fix it

Check and update the target role's trust policy:
```bash
# View the target role's trust policy
aws iam get-role --role-name TargetRole \
  --query 'Role.AssumeRolePolicyDocument'
```

The trust policy must include the calling principal:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::123456789012:user/deploy"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "my-external-id"
        }
      }
    }
  ]
}
```

Update it with:
```bash
aws iam update-assume-role-policy --role-name TargetRole \
  --policy-document file://trust-policy.json
```

Also ensure the calling user has permission to assume the role:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::987654321098:role/TargetRole"
    }
  ]
}
```

If using external-id, include it in the assume call:
```bash
aws sts assume-role \
  --role-arn arn:aws:iam::987654321098:role/TargetRole \
  --role-session-name my-session \
  --external-id my-external-id
```

## Still not working?
- Cross-account roles require the full ARN in the trust policy, including the correct account ID.
- Check for `Condition` blocks in the trust policy: `aws:SourceIp`, `aws:SourceVpc`, or `sts:ExternalId` restrictions will silently deny if not met.
- If the calling identity is itself an assumed role, the trust policy must reference the role ARN, not the session ARN.
- Use CloudTrail to see the exact denial reason: search for `AssumeRole` events with `errorCode: AccessDenied`.
