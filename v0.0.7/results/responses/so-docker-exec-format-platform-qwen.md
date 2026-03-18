The error message "Docker: exec /usr/bin/sh: exec format error" indicates that Docker is unable to execute a shell script or executable file because of an incorrect execution format. This typically happens when you're trying to run a binary compiled for one architecture (e.g., ARM) on another architecture (e.g., x86).

### Root Cause:
1. **Architecture Mismatch**: The image built on your Mac (which likely uses the `arm64` or `armv7` architecture due to Apple's M1/M2 chip) is trying to run a binary compiled for an x86 architecture.
   
   - If you're using Docker, it will try to execute the script as `/usr/bin/sh`, which expects a shell script (`.sh`) but finds a binary instead.

### How to Fix It:
To resolve this issue, ensure that your image is built and run on the same architecture. Here are some steps:

1. **Build Your Image with the Same Architecture**:
   - If you're using Dockerfile or any build system, make sure it's configured for the correct architecture.
   
2. **Run the Container with the Correct Architecture**:
   - Ensure that when you run your container, you specify the appropriate architecture.

### Example:

#### 1. Build Your Image on an ARM64/M1 Chip (e.g., macOS):
```bash
docker build --platform=linux/arm64/v8 .
```

#### 2. Run the Container with ARM64 Architecture:
```bash
docker run -it --rm --platform=linux/arm64/v8 your_image_name
```

### Additional Tips:

- **Dockerfile Configuration**:
  Ensure that your Dockerfile is configured to build for the correct architecture.
  
  ```Dockerfile
  FROM ubuntu:latest

  # Build for ARM64 (e.g., M1/M2)
  RUN apt-get update && \
      apt-get install -y --no-install-recommends \
          gcc g++ make git wget curl libssl-dev libffi-dev

  # Add your commands here to build the image
  ```

- **Docker Run Command**:
  When running a container, specify the correct architecture:

  ```bash
  docker run -it --rm --platform=linux/arm64/v8 your_image_name
  ```

By ensuring that your Dockerfile and container configuration are aligned with the same architecture, you should be able to resolve the "exec format error" issue.
