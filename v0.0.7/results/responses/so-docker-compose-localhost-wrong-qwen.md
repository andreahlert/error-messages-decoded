The error message "Using Docker: SQLSTATE[HY000] [2002] No such file or directory" indicates that your PHP application cannot establish a connection to the MySQL database running inside a Docker container.

### Root Cause:
1. **Docker Container Configuration**: The MySQL container is not accessible from outside of it, which means you can't connect to it using `localhost` because it's only accessible within the same network as the container.
2. **Network Configuration**: Your application and the MySQL database are likely running in separate Docker networks or containers that don’t communicate with each other.

### Steps to Fix:

#### 1. Ensure Correct Network Configuration:
   - Make sure your PHP application is part of the same Docker network as the MySQL container.
   - If you're using `docker-compose`, ensure both services are part of the same network, e.g., `mysql` and `php-app`.

```yaml
version: '3'
services:
  mysql:
    image: mysql:5.7
    networks:
      - phpapp-network

  php-app:
    build:
      context: .
      dockerfile: Dockerfile
    depends_on:
      - mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    networks:
      - phpapp-network

networks:
  phpapp-network:
```

#### 2. Update Your PHP Application Code:
   - Ensure your application code is using the correct connection string, which should be `mysql://username:password@localhost/dbname`.

```php
<?php
$servername = "localhost";
$username = "myuser";
$password = "mypassword";
$dbname = "mydatabase";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>
```

#### 3. Check Docker Compose File:
   - Ensure your `docker-compose.yml` file is correctly configured to expose the MySQL container.

```yaml
version: '3'
services:
  mysql:
    image: mysql:5.7
    networks:
      - phpapp-network

  php-app:
    build:
      context: .
      dockerfile: Dockerfile
    depends_on:
      - mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    networks:
      - phpapp-network

networks:
  phpapp-network:
```

#### 4. Verify Docker Containers:
   - Ensure both the MySQL container and your PHP application are running correctly.
   - Check if they are part of the same network.

```bash
docker ps
```

### Additional Tips:

- **Check Logs**: If you're still facing issues, check the logs for more detailed error messages that might help pinpoint the problem further.
  
  ```bash
  docker-compose logs php-app
  ```

By following these steps, you should be able to resolve the issue and successfully connect your PHP application to the MySQL database running inside a Docker container.
