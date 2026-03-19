Found it. The most likely cause is **Line 15 & 20**: the `COPY` commands are trying to copy files/directories that don't exist in your build context.

**Root causes:**

1. **Missing `pyproject.toml` or `uv.lock`** - Line 15 copies these before they're committed, but the build context doesn't see them.

2. **Missing `mcp-server/` directory** - Line 23 runs npm in `mcp-server/`, but if that directory doesn't exist in the build context, BuildKit fails parsing the subsequent layer.

3. **BuildKit syntax parsing failure** - When a COPY source doesn't exist, BuildKit's parser can fail with this vague error instead of a clearer "file not found" message.

**How to fix:**

1. **Verify files exist before building:**
   ```bash
   ls -la pyproject.toml uv.lock mcp-server/
   ```

2. **Build with full context visibility:**
   ```bash
   docker build --progress=plain -t your-image .
   ```
   This shows the exact step that fails.

3. **If `uv.lock` is optional**, change line 15:
   ```dockerfile
   COPY pyproject.toml /app/
   COPY uv.lock* /app/ 2>/dev/null || true
   ```
   Or just:
   ```dockerfile
   COPY pyproject.toml /app/
   ```

4. **If `mcp-server/` is truly missing**, either add it to the repo or skip that RUN step:
   ```dockerfile
   # RUN cd mcp-server && npm ci && npm run build
   ```

Check your git status: `?? pyproject.toml`, `?? uv.lock`, and `?? mcp-server/` are all untracked. Are these supposed to be in the repo?
