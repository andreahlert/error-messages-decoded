# Docker-in-Docker fails in GitHub Actions

> error during connect: Get http://docker:2376/v1.24/containers/json: dial tcp: lookup docker: no such host

## What happened
A GitHub Actions job tries to use Docker commands inside a container, but cannot connect to the Docker daemon because the `docker` hostname does not resolve.

## Why it happens
Docker-in-Docker (DinD) requires a Docker daemon running as a service alongside your job container. In GitHub Actions, you need to explicitly declare the `docker:dind` service and configure the connection. Without the service, there is no Docker daemon to connect to.

## How to fix it
```yaml
# .github/workflows/ci.yml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      docker:
        image: docker:dind
        options: --privileged
    container:
      image: docker:latest
      env:
        DOCKER_HOST: tcp://docker:2376
        DOCKER_TLS_CERTDIR: ""
    steps:
      - uses: actions/checkout@v4
      - run: docker version
      - run: docker build -t myapp .
```

```yaml
# Alternative: use the runner's Docker directly (no DinD needed)
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t myapp .
      # Docker is already available on ubuntu-latest runners
```

## Still not working?
If you must use DinD, ensure the service has `--privileged` mode. For TLS issues, set `DOCKER_TLS_CERTDIR` to empty string. If using a custom container image, make sure the Docker CLI is installed in it. Most GitHub Actions workflows do not need DinD because Docker is pre-installed on the runner.
