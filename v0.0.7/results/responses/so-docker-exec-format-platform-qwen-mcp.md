The error message "Docker: exec /usr/bin/sh: exec format error" indicates that Docker is unable to execute a shell script or executable file because of an incorrect execution format. This typically happens when you try to run a binary compiled for one architecture (e.g., ARM) on another architecture (e.g., x86).

### Root Cause:
1. **Architecture Mismatch**: The image built on your Mac with an ARM-based architecture is trying to be executed on a Linux server that has an x86 architecture.
2. **Binary Compatibility Issues**: Docker expects the binary to be compatible with its own execution environment, which might not match the one used during the build process.

### Steps to Fix:

#### 1. Build the Image Correctly:
   - Ensure you are building your image on a machine that matches the architecture of the target system (x86 in this case).
   - Use Docker's `--platform` flag to specify the platform for which the image is built.
     ```sh
     docker build --platform=linux/amd64 .
     ```
   - Alternatively, you can use `docker buildx` with a specific builder that matches your target architecture:
     ```sh
     docker buildx build --builder=x86_64-linux-gnu .
     ```

#### 2. Use the Correct Architecture for Dockerfile:
   - If you are using a Dockerfile to build your image, ensure it is compatible with the architecture of the host system.
   - For example, if you have an ARM-based Dockerfile, make sure it runs on an x86 machine.

#### 3. Check Your Build Environment:
   - Ensure that your environment variables and paths are set correctly for both building and running Docker commands.
   - Verify that your build tools (e.g., `docker`, `make`, etc.) are compatible with the architecture you are using.

#### 4. Use a Containerized Solution:
   - If possible, run your application inside a container rather than directly on the host system.
   - This can help isolate the environment and avoid issues related to binary compatibility between different architectures.

### Example Commands:

- **Building an ARM-based Dockerfile for x86 Linux:**
  ```sh
  docker build --platform=linux/amd64 .
  ```

- **Running a container built on ARM with x86 architecture:**
  ```sh
  docker run -it your-image-name
  ```

By ensuring that the image is built and executed on the correct architecture, you should be able to resolve the "exec format error" issue.
