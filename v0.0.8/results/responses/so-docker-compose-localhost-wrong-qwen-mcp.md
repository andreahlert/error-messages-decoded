The error message "Using Docker: SQLSTATE[HY000] [2002] No such file or directory" indicates that your PHP application running inside a Docker container cannot connect to the MySQL database hosted on localhost.

### Root Cause:
1. **Docker Networking Issue**: The default networking mode in Docker is `bridge`, which means containers are isolated from each other and do not share the same network namespace by default.
2. **MySQL Configuration**: Ensure that your MySQL server configuration allows connections from outside its host (localhost).
3. **PHP Configuration**: Check if PHP's `mysqli` or `PDO` extensions have been configured to connect to localhost.

### Steps to Fix:

#### 1. Change Docker Networking Mode:
   - If you are using a `bridge` network, change it to `host` mode.
     ```yaml
     networks:
       default:
         external: true
     ```
   - Alternatively, if you want the containers to share the same network namespace, use `container` or `service` mode.

#### 2. Configure MySQL to Allow Connections from Outside Host:
   - Edit your MySQL configuration file (usually `/etc/mysql/my.cnf` or `/etc/my.cnf`) and add the following line under the `[mysqld]` section:
     ```sql
     bind-address = 0.0.0.0
     ```
   - Restart the MySQL service to apply changes.

#### 3. Update PHP Configuration:
   - Ensure that your `php.ini` or `docker-compose.yml` file has the correct settings for connecting to localhost.
   - For example, in `docker-compose.yml`, you might have something like this:
     ```yaml
     version: '3'
     services:
       web:
         image: php:7.4-fpm
         environment:
           - PHP_FCGI_CHILDREN=5
           - PHP_FCGI_MAX_REQUESTS=100
         volumes:
           - ./php.ini:/usr/local/etc/php/conf.d/your-php-config.ini
     ```
   - In `php.ini`, ensure that the MySQL connection settings are correct. For example, if your database is named `mydb` and you use a username and password:
     ```ini
     extension=mysqli
     mysqli.default_host=localhost
     mysqli.default_port=3306
     mysqli.default_user=myuser
     mysqli.default_password=mypassword
     ```

#### 4. Verify Docker Compose File:
   - Ensure that your `docker-compose.yml` file is correctly configured to connect to the MySQL container.
   - Example configuration:
     ```yaml
     version: '3'
     services:
       web:
         build: .
         ports:
           - "8080:80"
         depends_on:
           - db

       db:
         image: mysql:5.7
         environment:
           MYSQL_ROOT_PASSWORD: rootpassword
           MYSQL_DATABASE: mydb
           MYSQL_USER: myuser
           MYSQL_PASSWORD: mypassword
     ```

#### 5. Check Logs and Error Messages:
   - Look at the logs of your MySQL container to see if there are any additional errors or warnings that might help diagnose the issue.
   - Use `docker-compose up --build` to rebuild the containers, which can sometimes resolve connection issues.

By following these steps, you should be able to connect your PHP application running inside a Docker container to the MySQL database hosted on localhost.
