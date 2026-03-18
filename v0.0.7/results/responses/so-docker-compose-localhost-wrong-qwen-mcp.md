The error message "Using Docker: SQLSTATE[HY000] [2002] No such file or directory" indicates that your PHP application running inside a Docker container cannot connect to the MySQL database hosted on localhost.

### Root Cause:
1. **Incorrect Hostname in Connection String**:
   - The hostname `localhost` is not correct for connecting to a remote MySQL server.
   - You should use the IP address of the host machine where the MySQL server is running instead of `localhost`.

2. **Docker Networking Configuration**:
   - Ensure that your Docker networking configuration allows communication between the PHP application and the MySQL database.

### Steps to Fix:

#### 1. Update the Connection String in Your PHP Application
- Replace `localhost` with the IP address of the host machine where your MySQL server is running.
- Example: If your MySQL server runs on `192.168.1.10`, update the connection string as follows:
  ```php
  $pdo = new PDO("mysql:host=192.168.1.10;dbname=mydatabase", "username", "password");
  ```

#### 2. Check Docker Networking Configuration
- Ensure that your Docker network allows communication between the host machine and the container.
- If you are using a bridge network, make sure it is correctly configured.

#### 3. Verify MySQL Service in Docker Compose File
- Make sure your `docker-compose.yml` file has the correct configuration for the MySQL service:
  ```yaml
  version: '3.8'

  services:
    db:
      image: mysql:5.7
      environment:
        MYSQL_ROOT_PASSWORD: rootpassword
        MYSQL_DATABASE: mydatabase
        MYSQL_USER: user
        MYSQL_PASSWORD: password

    phpmyadmin:
      image: phpmyadmin/phpmyadmin
      ports:
        - "8080:80"
      depends_on:
        db:
          condition: service_healthy
  ```

#### 4. Check Firewall and Security Groups
- Ensure that the firewall rules allow traffic on port `3306` (the default MySQL port).
- If you are using security groups, make sure they permit inbound connections to port `3306`.

### Additional Tips:
- **Check Docker Logs**: Look at the logs of your container for more detailed error messages.
  ```bash
  docker-compose logs -f
  ```
- **Restart Services**: Sometimes restarting the services can help resolve connectivity issues.

By following these steps, you should be able to connect your PHP application running inside a Docker container to the MySQL database hosted on localhost.
