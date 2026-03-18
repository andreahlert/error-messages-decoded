# Rate exceeded / Throttling

> An error occurred (Throttling) when calling the DescribeInstances operation: Rate exceeded
> An error occurred (TooManyRequestsException) when calling the XXX operation: Too Many Requests
> botocore.exceptions.ClientError: An error occurred (ThrottlingException)

## What happened

You're making too many API calls to an AWS service in a short period. AWS is rate-limiting your account/region to protect the service.

## Why it happens

- A script is calling an API in a tight loop without delays
- Multiple services/scripts are hitting the same API simultaneously
- You're using `describe` or `list` calls on every request instead of caching results
- Auto-scaling or deployment scripts polling too frequently

## How to fix it

**Add exponential backoff with jitter:**

```python
import time
import random
import boto3
from botocore.exceptions import ClientError

def call_with_backoff(func, *args, max_retries=5, **kwargs):
    for attempt in range(max_retries):
        try:
            return func(*args, **kwargs)
        except ClientError as e:
            if e.response['Error']['Code'] in ('Throttling', 'TooManyRequestsException'):
                wait = (2 ** attempt) + random.uniform(0, 1)
                time.sleep(wait)
            else:
                raise
    raise Exception("Max retries exceeded")
```

**Use AWS SDK built-in retry configuration:**

```python
import boto3
from botocore.config import Config

config = Config(
    retries={'max_attempts': 10, 'mode': 'adaptive'}
)
client = boto3.client('ec2', config=config)
```

```javascript
// AWS SDK v3 for JavaScript
const { EC2Client } = require("@aws-sdk/client-ec2");
const client = new EC2Client({
  maxAttempts: 10,
});
```

**Cache results instead of polling:**

```python
# Instead of calling describe_instances on every request,
# cache the result for a reasonable duration
from functools import lru_cache

@lru_cache(maxsize=1)
def get_instances():
    return ec2.describe_instances()
```

## Don't do this

- Don't just add `time.sleep(1)` in a loop. Use exponential backoff with jitter, or all your parallel workers will retry at the same time.
- Don't request a service limit increase as the first step. Fix the code that's hammering the API.

## Still not working?

- Check CloudTrail for which identity/service is making the most calls.
- Some services have hard limits that can't be increased. DynamoDB, for example, has per-table and per-account limits.
- Use pagination instead of making separate calls. `list_objects_v2` with pagination makes fewer API calls than calling it repeatedly with different prefixes.
