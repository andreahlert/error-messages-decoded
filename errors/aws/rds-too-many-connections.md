# RDS too many connections for role

> FATAL: too many connections for role

## What happened
Your application cannot connect to RDS because the maximum number of connections for that database role has been reached.

## Why it happens
RDS instances have a fixed `max_connections` limit based on instance size (e.g., db.t3.micro has ~66 connections). Each connection consumes memory and has SSL handshake overhead. When multiple application servers, Lambda functions, or background workers each maintain their own connection pools, the total easily exceeds the limit. Each SSL handshake also adds connection overhead that reduces effective capacity.

## How to fix it

Use RDS Proxy for connection pooling:
```bash
# Create an RDS Proxy
aws rds create-db-proxy \
  --db-proxy-name my-proxy \
  --engine-family POSTGRESQL \
  --auth '[{"AuthScheme":"SECRETS","SecretArn":"arn:aws:secretsmanager:...","IAMAuth":"DISABLED"}]' \
  --role-arn arn:aws:iam::123:role/rds-proxy-role \
  --vpc-subnet-ids subnet-xxx subnet-yyy

# Update your connection string to point to the proxy endpoint
# my-proxy.proxy-xxx.us-east-1.rds.amazonaws.com
```

Or use PgBouncer as a sidecar/standalone connection pooler:
```bash
# Install pgbouncer
apt-get install pgbouncer

# pgbouncer.ini
# [databases]
# mydb = host=mydb.xxx.rds.amazonaws.com port=5432 dbname=mydb
# [pgbouncer]
# pool_mode = transaction
# max_client_conn = 500
# default_pool_size = 20
```

Right-size your application's connection pool based on the total across all instances:
```python
# If you have 4 app servers, each pool should be max_connections / 4
# For db.t3.medium (~66 connections), that's ~15 per server
engine = create_engine(
    "postgresql://...",
    pool_size=10,
    max_overflow=5,
)
```

## Still not working?
- Check current connections: `SELECT count(*), usename, state FROM pg_stat_activity GROUP BY usename, state;`
- For Lambda functions, always use RDS Proxy. Each Lambda invocation can open a new connection, quickly exhausting limits.
- Consider upgrading the RDS instance size for a higher `max_connections` limit, but pooling is the better long-term solution.
- Kill idle connections: `SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE state = 'idle' AND query_start < now() - interval '10 minutes';`
