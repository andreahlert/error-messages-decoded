# CloudFormation UPDATE_ROLLBACK_FAILED

> UPDATE_ROLLBACK_FAILED

## What happened
A CloudFormation stack update failed and then the automatic rollback also failed, leaving the stack in an unrecoverable state.

## Why it happens
During a failed update, CloudFormation tries to roll back to the previous state. If the previous state's resources have been manually modified or deleted outside of CloudFormation, or if IAM permissions have changed, the rollback itself fails. The stack is now stuck in `UPDATE_ROLLBACK_FAILED` and cannot be updated or deleted normally.

## How to fix it

Use `ContinueUpdateRollback` to skip the problematic resources:
```bash
# First, identify which resources failed
aws cloudformation describe-stack-events \
  --stack-name my-stack \
  --query 'StackEvents[?ResourceStatus==`UPDATE_FAILED`].[LogicalResourceId,ResourceStatusReason]' \
  --output table

# Continue the rollback, skipping the failed resources
aws cloudformation continue-update-rollback \
  --stack-name my-stack \
  --resources-to-skip LogicalResourceId1 LogicalResourceId2
```

In the AWS Console:
1. Go to CloudFormation > your stack
2. Click "Stack actions" > "Continue update rollback"
3. In Advanced options, select resources to skip
4. Click "Continue update rollback"

After the rollback succeeds, manually fix the skipped resources:
```bash
# Check the stack's current state
aws cloudformation describe-stack-resources --stack-name my-stack

# The skipped resources will be out of sync
# You may need to manually recreate or import them
```

## Still not working?
- If `ContinueUpdateRollback` still fails, check IAM permissions: the role used by CloudFormation needs permission to delete/modify the stuck resources.
- For nested stacks, you may need to fix the child stack first before the parent can roll back.
- If the stack is completely stuck, you can delete it with `--retain-resources` to keep the problematic resources and recreate the stack with import.
- Check CloudTrail logs for the specific API call that failed during rollback.
