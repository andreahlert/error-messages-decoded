**Root cause:** Your PHP container is trying to connect to `localhost`, which resolves to the container's own loopback (127.0.0.1), not to your MySQL container. Docker Compose doesn't automatically expose MySQL via localhost across containers.

**Fix:** Replace `localhost` with your MySQL service name in your database connection string.

In your `docker-compose.yml`, if your MySQL service is named `mysql` or `db`:

```php
// Change from:
$host = 'localhost';

// To:
$host = 'mysql';  // or 'db' - whatever your service name is in docker-compose.yml
```

**Why this works:** Docker Compose creates an internal DNS network where services can reach each other by their service names. The PHP container can then resolve `mysql` to the MySQL container's internal IP.

**Double-check:**
1. Verify the service name in your `docker-compose.yml` (the key under `services:`)
2. Ensure PHP and MySQL are in the same compose file or network
3. Confirm the MySQL container is running: `docker-compose ps`

If you need to connect from the host machine (outside Docker), use `localhost`, but from within a container, always use the service name.
