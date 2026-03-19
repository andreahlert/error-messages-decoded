The error "Docker: exec /usr/bin/sh: exec format error" typically indicates that Docker cannot execute a shell script or binary file because of an incorrect execution format. This can happen for several reasons, including:

1. **Incorrect File Permissions**: The executable file (e.g., `sh`, `bash`) might not have the correct permissions set to allow Docker to run it.

2. **File Encoding Issues**: If the file is encoded in a non-standard encoding that Docker doesn't recognize or support, it can cause this error.

3. **Incorrect File Type**: The file might be a script (e.g., `sh`, `bash`) but not executable by default on your system.

4. **Docker Version Compatibility**: There could be compatibility issues between the version of Docker you are using and the operating systems or architectures involved.

### Steps to Fix:

1. **Check File Permissions**:
   Ensure that the file has execute permissions for the user running Docker (usually `root` or a specific user). You can do this by running:
   ```bash
   chmod +x /path/to/your/script.sh
   ```

2. **Verify Encoding**:
   If you suspect the encoding issue, check if the script is encoded in UTF-8 or another standard encoding that Docker supports.

3. **Check File Type**:
   Ensure that the file is indeed executable by running:
   ```bash
   ls -l /path/to/your/script.sh
   ```
   This should show `x` permissions for the owner, indicating it's an executable script.

4. **Update Docker and System Packages**:
   Make sure you have the latest versions of Docker and any system packages that might affect compatibility with your environment.

5. **Rebuild Image**:
   If none of the above steps work, rebuild your Docker image to ensure it is compatible with both environments (M1/M2 Mac/Linux).

6. **Check for Known Issues**:
   Look up if there are known issues related to Docker and macOS/x86 compatibility on Stack Overflow or other tech forums.

### Example Commands:

- Check file permissions:
  ```bash
  ls -l /path/to/your/script.sh
  ```

- Verify encoding (if script is in a non-standard encoding):
  ```bash
  file /path/to/your/script.sh
  ```

By following these steps, you should be able to resolve the "exec format error" issue and successfully run your Docker image on an x86 Linux server.
