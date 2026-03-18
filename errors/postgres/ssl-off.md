# PostgreSQL rejects connection: no pg_hba.conf entry

> FATAL: no pg_hba.conf entry for host "192.168.1.50", user "myapp", database "production", no encryption

## What happened

PostgreSQL's host-based authentication file (`pg_hba.conf`) doesn't have a rule that allows your specific combination of host, user, database, and connection method.

## Why it happens

`pg_hba.conf` is a whitelist. If there's no matching line for your connection, it's rejected. The "no encryption" part means you're connecting without SSL and the server requires it, or there's simply no rule for your IP address.

## How to fix it

```bash
# Find pg_hba.conf
sudo -u postgres psql -c "SHOW hba_file;"
# Usually: /etc/postgresql/16/main/pg_hba.conf

# Edit it and add a rule for your connection
sudo nano /etc/postgresql/16/main/pg_hba.conf
```

Add a line (order matters, first match wins):

```
# TYPE  DATABASE    USER        ADDRESS         METHOD
host    production  myapp       192.168.1.0/24  scram-sha-256
hostssl production  myapp       192.168.1.0/24  scram-sha-256
```

Then reload (no restart needed):

```bash
sudo -u postgres psql -c "SELECT pg_reload_conf();"
# or
sudo systemctl reload postgresql
```

## Don't do this

- Don't add `host all all 0.0.0.0/0 trust`. That lets anyone connect without a password from anywhere. This is how databases get wiped by ransomware bots.
- Don't use `md5` for new setups. Use `scram-sha-256` which is the modern default and more secure.

## Still not working?

If the error says "no encryption" and you want to require SSL:

```bash
# In postgresql.conf
ssl = on
ssl_cert_file = '/path/to/server.crt'
ssl_key_file = '/path/to/server.key'

# In pg_hba.conf, use hostssl instead of host
hostssl production myapp 192.168.1.0/24 scram-sha-256
```

If your client needs to disable SSL verification for testing:

```bash
psql "host=myserver dbname=production user=myapp sslmode=require"
```

Common `sslmode` values: `disable`, `allow`, `prefer` (default), `require`, `verify-ca`, `verify-full`.
