FROM python:3.12-slim

# Node.js for MCP server
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git jq \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Claude CLI
RUN curl -fsSL https://cli.anthropic.com/install.sh | sh \
    && ln -sf /root/.claude/local/bin/claude /usr/local/bin/claude

# Python deps
COPY pyproject.toml uv.lock* /app/
WORKDIR /app
RUN pip install --no-cache-dir flytekit anthropic requests

# Copy project
COPY . /app

# Build MCP server
RUN cd mcp-server && npm ci && npm run build

# Default: run the Flyte workflow
ENTRYPOINT ["python", "flyte/workflow.py"]
