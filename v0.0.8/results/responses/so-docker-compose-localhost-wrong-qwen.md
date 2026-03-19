The error message "Using Docker: SQLSTATE[HY000] [2002] No such file or directory" indicates that your PHP application running inside a Docker container cannot connect to the MySQL database hosted on localhost.

### Root Cause:
1. **Docker Networking Issue**: The default networking mode in Docker is `bridge`, which means containers are isolated from each other and do not share the same network namespace. This can cause issues if you try to access services that require external IP addresses or ports.
2. **Incorrect Hostname/IP Address**: Your application might be trying to connect to MySQL using a hostname (`localhost`) instead of an IP address, which is incorrect for Docker containers.

### Steps to Fix:

#### 1. Ensure Correct Network Configuration:
   - If you are running multiple services in the same container (e.g., PHP and MySQL), make sure they share the same network namespace.
   - Use `host` networking mode if your application requires external access or specific IP addresses.

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "8080:80"
    networks:
      - my-network

  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    ports:
      - "3306:3306"
    networks:
      - my-network

networks:
  my-network:
    driver: bridge
```

#### 2. Update Your Application Code:
   - Ensure your application code uses the correct hostname or IP address for MySQL.
   - If you are using a local development environment, make sure to run `docker-compose up` in the same directory as your PHP files.

```php
<?php
// Assuming you have a connection string like this:
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
   - Ensure your `docker-compose.yml` file is correctly configured for the network mode.

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "8080:80"
    networks:
      - my-network

  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    ports:
      - "3306:3306"
    networks:
      - my-network

networks:
  my-network:
    driver: bridge
```

#### 4. Verify Docker Containers:
   - Ensure that the MySQL container is running and accessible.
   - Check if there are any firewall rules blocking access to port `3306`.

```bash
sudo iptables -L
```

If you still encounter issues, consider using a different network mode like `host` or `none`, which might help in isolating your application from the host's networking:

```yaml
version: '3'
services:
  web:
    build: .
    ports:
      - "8080:80"
    networks:
      - my-network

  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydatabase
      MYSQL_USER: myuser
      MYSQL_PASSWORD: mypassword
    ports:
      - "3306:3306"
    networks:
      - my-network

networks:
  my-network:
    driver: bridge
```

By following these steps, you should be able to resolve the issue and successfully connect your PHP application to the MySQL database running inside a Docker container.
