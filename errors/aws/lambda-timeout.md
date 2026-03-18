# Task timed out after X seconds

> Task timed out after 3.00 seconds
> 2024-01-15T10:30:00.000Z xxx Task timed out after 30.00 seconds

## What happened

Your Lambda function didn't finish execution before the configured timeout. AWS killed it mid-execution. No response was returned to the caller.

## Why it happens

- The function is doing something slow (database query, API call, file processing)
- A downstream service is unreachable and the SDK waits for the default timeout (usually 120s)
- Cold start + execution time exceeds the limit
- The function is stuck in an infinite loop or deadlock

## How to fix it

**Increase the timeout (quick fix):**

```bash
aws lambda update-function-configuration \
  --function-name my-function \
  --timeout 30
```

Maximum is 900 seconds (15 minutes). If you need more, Lambda isn't the right service.

**Add timeouts to all external calls (real fix):**

```python
import requests
import boto3
from botocore.config import Config

# HTTP calls
response = requests.get('https://api.example.com', timeout=5)

# AWS SDK calls
config = Config(connect_timeout=5, read_timeout=10)
client = boto3.client('dynamodb', config=config)
```

```javascript
// Node.js
const response = await fetch(url, { signal: AbortSignal.timeout(5000) });

// AWS SDK v3
const client = new DynamoDBClient({
  requestHandler: { requestTimeout: 5000 },
});
```

**Check what's actually slow:**

```python
import time

def handler(event, context):
    start = time.time()
    # ... your code ...
    print(f"Step 1 took {time.time() - start:.2f}s")
    remaining = context.get_remaining_time_in_millis()
    print(f"Time remaining: {remaining}ms")
```

## Don't do this

- Don't set timeout to 900s "just to be safe." You'll pay for idle compute time and hide performance issues.
- Don't use Lambda for long-running tasks. Use Step Functions, ECS, or Fargate instead.

## Still not working?

- If the function connects to a VPC, DNS resolution and ENI attachment can add 5-10 seconds of cold start. Use provisioned concurrency or VPC-attached NAT.
- Check if the function is waiting on a connection pool that's exhausted. Reusing connections across invocations (outside the handler) helps.
- If calling RDS, check if the database has too many connections. Use RDS Proxy.
- Monitor with X-Ray to see exactly which call is slow.
