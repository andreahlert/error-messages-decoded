# libcuda.so.1 not found in Docker container

> ImportError: libcuda.so.1: cannot open shared object file: No such file or directory

## What happened
A Python library (PyTorch, TensorFlow, etc.) tried to load the CUDA driver library inside a Docker container but the GPU runtime is not available.

## Why it happens
Docker containers do not have access to the host's GPU by default. The `libcuda.so.1` library is provided by the NVIDIA driver on the host and must be mounted into the container using the NVIDIA Container Toolkit. Without the `--gpus` flag or `nvidia` runtime, the container cannot see the GPU or its drivers.

## How to fix it

Install the NVIDIA Container Toolkit on the host:
```bash
# Ubuntu/Debian
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

Run the container with GPU access:
```bash
docker run --gpus all -it my-cuda-image python -c "import torch; print(torch.cuda.is_available())"
```

Or in docker-compose:
```yaml
services:
  app:
    image: my-cuda-image
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```

Use an appropriate NVIDIA base image:
```dockerfile
FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04
```

## Still not working?
- Verify the host has NVIDIA drivers: `nvidia-smi` should work on the host.
- Check that the Docker daemon is configured with the nvidia runtime: `docker info | grep -i runtime`.
- If you do not need GPU and want CPU-only, install the CPU variant of your library (e.g., `pip install torch --index-url https://download.pytorch.org/whl/cpu`).
