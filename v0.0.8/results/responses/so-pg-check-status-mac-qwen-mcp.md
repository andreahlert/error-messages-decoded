The error you're encountering suggests that there might be an issue with starting or stopping your PostgreSQL server on macOS. Here are some steps to check and potentially resolve this:

### 1. **Check if PostgreSQL is Running**
   - Open Terminal.
   - Run the following command:
     ```bash
     pg_ctl status
     ```
   - If PostgreSQL is running, you should see output similar to:
     ```
     postgresql-14-main: active (running)
     ```

### 2. **Check if PostgreSQL is Stopped**
   - To stop PostgreSQL, run:
     ```bash
     sudo psql -c "SELECT pg_stop_backend();"
     ```
   - If you see output similar to:
     ```
     SELECT * FROM pg_stop_backend();
     ```
     This indicates that the server has been stopped.

### 3. **Check if PostgreSQL is Installed**
   - Ensure that PostgreSQL is installed on your system by running:
     ```bash
     brew list postgresql
     ```
   - If it's not installed, you can install it using Homebrew:
     ```bash
     brew install postgresql
     ```

### 4. **Check for Errors in the Log Files**
   - PostgreSQL logs are typically located at `/usr/local/var/postgres/`. Check if there are any error messages or warnings in these files.
   - You can view specific log files using:
     ```bash
     tail -f /usr/local/var/postgres/server.log
     ```

### 5. **Check for Permissions Issues**
   - Ensure that the PostgreSQL user has the necessary permissions to start and stop the server. The default user is `postgres`.
   - You can check the current user by running:
     ```bash
     whoami
     ```
   - If you're not using `postgres`, ensure that the correct user owns the `/usr/local/var/postgres` directory.

### 6. **Check for Conflicting Services**
   - Sometimes, other services might be conflicting with PostgreSQL. You can check which processes are running by:
     ```bash
     ps aux | grep postgresql
     ```
   - If you find any conflicts, try stopping or disabling them to see if that resolves the issue.

### 7. **Check for System Resources**
   - Ensure that your system has enough resources (CPU, memory) to run PostgreSQL.
   - You can check CPU and memory usage with:
     ```bash
     top
     ```
   - If you find that PostgreSQL is using a significant amount of resources, consider upgrading or optimizing the server.

### 8. **Check for System Updates**
   - Ensure your macOS system is up-to-date as there might be bugs fixed in newer versions.
   - You can check for updates by going to `System Preferences > Software Update`.

### 9. **Restart PostgreSQL**
   - If none of the above steps resolve the issue, you may need to restart PostgreSQL:
     ```bash
     sudo psql -c "SELECT pg_ctl start"
     ```

If after following these steps your PostgreSQL server is still not running or starting correctly, it might be helpful to consult the official PostgreSQL documentation or seek help from a professional database administrator.
