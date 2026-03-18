# Docker image pull access denied or manifest unknown

> Error response from daemon: pull access denied for myapp, repository does not exist or may require 'docker login'
> Error response from daemon: manifest for myapp:latest not found: manifest unknown

## What happened

Docker can't find the image you're trying to pull. Either the image name is wrong, the tag doesn't exist, or it's a private image and you're not authenticated.

## Why it happens

Three common causes: a typo in the image name, referencing a tag that was never pushed (like `latest` when only versioned tags exist), or trying to pull from a private registry without logging in first.

## How to fix it

```bash
# Check for typos - is the name right?
docker search myapp

# Login if it's private
docker login
# or for a specific registry
docker login ghcr.io
docker login <your-account>.dkr.ecr.<region>.amazonaws.com

# For AWS ECR specifically
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account>.dkr.ecr.us-east-1.amazonaws.com
```

If the tag doesn't exist, check available tags on Docker Hub or your registry, then pull a specific one:

```bash
docker pull node:20-alpine  # instead of node:latest
```

## Don't do this

- Don't assume `latest` always exists. Many projects stopped pushing a `latest` tag.
- Don't confuse the local image name from `docker build -t myapp .` with a registry image. Local images aren't on Docker Hub.

## Still not working?

If you pushed the image yourself, make sure the full registry path matches:

```bash
# This won't work
docker push myapp

# This will
docker tag myapp ghcr.io/username/myapp:v1
docker push ghcr.io/username/myapp:v1
```

For GitHub Container Registry, you need a PAT with `read:packages` scope. Classic GitHub tokens don't work.
