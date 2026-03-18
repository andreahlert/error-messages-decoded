**Root cause**: You're using `localhost` as the database host. In Docker, `localhost` inside a PHP container refers to the container itself, not the host machine. More specifically, when PHP tries to connect to `localhost`, it attempts to use a Unix socket (typically `/var/run/mysqld/mysqld.sock`) which doesn't exist in the PHP container because the socket is on the MySQL container's filesystem.

**How to fix**:

Use the **MySQL service name** from your `docker-compose.yml` as the hostname instead of `localhost`.

Example:

```yaml
# docker-compose.yml
services:
  php:
    # ...
  mysql:
    image: mysql:latest
    # ...
```

In your PHP app, change:
```php
// ❌ Wrong
$db = new PDO('mysql:host=localhost;dbname=mydb', 'user', 'pass');

// ✅ Correct
$db = new PDO('mysql:host=mysql;dbname=mydb', 'user', 'pass');
```

Or in your `.env` or config:
```
DB_HOST=mysql  # Use the service name, not localhost
```

Docker Compose creates an internal DNS that resolves service names to their container IPs. The PHP and MySQL containers communicate over the internal network using the service name as the hostname, not via Unix sockets or `localhost`.
