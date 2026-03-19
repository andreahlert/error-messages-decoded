The error message "failed to compute cache key: not found" typically indicates that Docker cannot find a previously computed cache key for your build context. This can happen due to several reasons, including network issues or changes in the directory structure.

### Root Cause:

1. **Network Issues**: If you're building from a remote repository (e.g., GitHub, GitLab), ensure that your internet connection is stable and working properly.
2. **Directory Structure Changes**: Docker caches build context based on the current state of the directory. Any changes to the directory structure can cause this error.
3. **Incorrect Build Context Path**: Ensure that you're providing the correct path to the build context in your `docker build` command.

### Steps to Fix:

1. **Check Network Connectivity**:
   - Verify if there are any network issues preventing Docker from accessing the internet or the repository where your image is being built.
   - Try building the image locally (without using a remote registry) to see if the issue persists.

2. **Verify Directory Structure**:
   - Ensure that the directory structure matches what you expect for the build context.
   - If you're using a Dockerfile, make sure it's correctly configured and doesn't contain any errors or issues.

3. **Use `--cache-from` Option**:
   - When building from a remote repository, use the `--cache-from` option to specify the base image that should be used for caching.
     ```sh
     docker build --build-arg FROM=base_image --tag=myimage .
     ```
   - This ensures Docker uses the correct base image and caches it properly.

4. **Check Docker Version**:
   - Ensure you're using a compatible version of Docker. Sometimes, issues can arise due to incompatibilities between different versions.
   - Update Docker if necessary: `docker system update`

5. **Clean Cache**:
   - If the issue persists, try cleaning the cache and rebuilding from scratch.
     ```sh
     docker rmi $(docker images -q)
     docker build --no-cache .
     ```

6. **Check for Permissions Issues**:
   - Ensure that you have the necessary permissions to read/write in the directory where Docker is trying to access.

### Example Commands:

- Building locally (without a remote repository):
  ```sh
  docker build -t myimage .
  ```
  
- Using a remote registry:
  ```sh
  docker build --build-arg FROM=base_image --tag=myimage .
  ```

By following these steps, you should be able to resolve the "failed to compute cache key: not found" error. If the issue persists, consider providing more details about your environment and configuration for further assistance.
