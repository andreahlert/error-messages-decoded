# CloudWatch log group does not exist

> An error occurred (ResourceNotFoundException): The specified log group does not exist

## What happened
A service (Lambda, ECS, API Gateway) tried to write logs to a CloudWatch Log Group that does not exist, and the service's IAM role does not have permission to create it.

## Why it happens
CloudWatch Log Groups are not created automatically unless the service's execution role has `logs:CreateLogGroup` permission. Lambda and ECS will attempt to create the log group on first invocation, but if the IAM role only has `logs:PutLogEvents` and `logs:CreateLogStream`, the log group creation fails silently and subsequent log writes fail with ResourceNotFoundException.

## How to fix it

Add the required permissions to the execution role:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

Apply with CLI:
```bash
aws iam put-role-policy \
  --role-name my-lambda-execution-role \
  --policy-name CloudWatchLogs \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }]
  }'
```

Or create the log group explicitly in your infrastructure code:
```bash
aws logs create-log-group --log-group-name /aws/lambda/my-function
```

In CloudFormation/Terraform:
```yaml
# CloudFormation
MyLogGroup:
  Type: AWS::Logs::LogGroup
  Properties:
    LogGroupName: /aws/lambda/my-function
    RetentionInDays: 14
```

## Still not working?
- Check the exact log group name. Lambda uses `/aws/lambda/<function-name>`, ECS uses `/ecs/<task-definition>`, API Gateway uses `API-Gateway-Execution-Logs_<api-id>/<stage>`.
- Verify the execution role is actually attached to the service: `aws lambda get-function-configuration --function-name my-func --query 'Role'`.
- If using a VPC endpoint for CloudWatch Logs, check that the security group allows HTTPS (443) outbound.
- Check the region: log groups are regional. Make sure the service and log group are in the same region.
