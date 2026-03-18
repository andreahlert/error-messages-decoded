# No export named 'xxx' found in stack 'yyy'

> No export named 'MyVpcId' found in stack 'NetworkStack'
> Export 'NetworkStack:MyVpcId' cannot be deleted as it is in use by 'AppStack'

## What happened

A CloudFormation stack is trying to import a value exported by another stack, but that export doesn't exist or has a different name. Alternatively, you're trying to delete/update an export that another stack still references.

## Why it happens

- The exporting stack hasn't been deployed yet
- The export name was changed or removed in a recent deploy
- You're deploying stacks in the wrong order
- A typo in the `Fn::ImportValue` reference

## How to fix it

**Check what exports actually exist:**

```bash
aws cloudformation list-exports --query "Exports[].{Name:Name,Value:Value}" --output table
```

**Make sure the export name matches exactly:**

```yaml
# In the exporting stack
Outputs:
  VpcId:
    Value: !Ref MyVpc
    Export:
      Name: NetworkStack-VpcId  # This is the export name

# In the importing stack
Resources:
  MyResource:
    Properties:
      VpcId: !ImportValue NetworkStack-VpcId  # Must match exactly
```

**Deploy stacks in the right order:**

```bash
# Deploy the exporting stack first
aws cloudformation deploy --stack-name NetworkStack --template-file network.yaml

# Then deploy the importing stack
aws cloudformation deploy --stack-name AppStack --template-file app.yaml
```

**If you can't delete an export because another stack uses it:**

```bash
# Find which stacks import this value
aws cloudformation list-imports --export-name NetworkStack-VpcId
```

Then update or delete the importing stacks first.

## Don't do this

- Don't delete the exporting stack without first removing all `Fn::ImportValue` references in other stacks.
- Don't rename exports without a migration plan. All importing stacks break instantly.

## Still not working?

- Cross-region imports don't work. `Fn::ImportValue` only works within the same region.
- Cross-account imports don't work either. Use SSM Parameter Store or Secrets Manager for cross-account sharing.
- If stuck in a circular dependency between stacks, break the cycle by hardcoding the value temporarily, deploying, then switching back to `Fn::ImportValue`.
