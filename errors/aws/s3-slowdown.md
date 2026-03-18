# S3 SlowDown request rate throttling

> SlowDown: Please reduce your request rate

## What happened
AWS S3 is throttling your requests because you exceeded the request rate limit for a specific prefix (partition) in your bucket.

## Why it happens
S3 supports 5,500 GET/HEAD and 3,500 PUT/COPY/POST/DELETE requests per second per prefix. If all your objects share the same prefix (e.g., all files under `data/2024/`), all requests compete for the same partition's throughput. S3 automatically partitions based on key prefixes, but a sudden burst to a single prefix can trigger throttling.

## How to fix it

Randomize your key prefixes to distribute load across S3 partitions:
```bash
# Instead of: data/2024/01/file001.csv
# Use a hash prefix: a3f2/data/2024/01/file001.csv

# In Python:
import hashlib
key = "data/2024/01/file001.csv"
prefix = hashlib.md5(key.encode()).hexdigest()[:4]
s3_key = f"{prefix}/{key}"
```

Implement exponential backoff for retries:
```python
import boto3
from botocore.config import Config

config = Config(
    retries={
        'max_attempts': 10,
        'mode': 'adaptive'  # uses exponential backoff with token bucket
    }
)
s3 = boto3.client('s3', config=config)
```

Use CloudFront for read-heavy workloads:
```bash
aws cloudfront create-distribution \
  --origin-domain-name mybucket.s3.amazonaws.com \
  --default-cache-behavior '{"ViewerProtocolPolicy":"redirect-to-https","AllowedMethods":{"Quantity":2,"Items":["GET","HEAD"]}}'
```

## Still not working?
- Spread requests across multiple prefixes. Even a date-based prefix like `2024/01/15/` helps distribute partitions.
- For listing operations, use `ListObjectsV2` with a delimiter to reduce the number of keys scanned per request.
- If doing bulk uploads, use S3 Transfer Acceleration or multipart uploads with parallelism across different prefixes.
- Contact AWS Support to request a pre-warming of your bucket if you expect a sudden spike in traffic.
