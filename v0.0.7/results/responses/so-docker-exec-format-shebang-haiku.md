The error occurs when the entrypoint script either:

1. **Has Windows line endings (CRLF)** — Most common cause
   - Docker interprets `\r\n` as invalid binary format
   - Fix in your Dockerfile:
     ```dockerfile
     COPY entrypoint.sh /app/entrypoint.sh
     RUN dos2unix /app/entrypoint.sh  # or sed -i 's/\r$//' /app/entrypoint.sh
     RUN chmod +x /app/entrypoint.sh
     ```
   - Or fix at source: Convert your script to LF in your editor (most editors have a line-ending selector)

2. **Lacks execute permission** — Secondary cause
   ```dockerfile
   RUN chmod +x /app/entrypoint.sh
   ```

3. **Missing/wrong shebang** — Less common
   - Script must start with `#!/bin/bash` or `#!/bin/sh`
   - Verify the shebang points to an interpreter that exists in the image

**Quick test:** If building locally, check if your script has `\r\n` endings:
```bash
file entrypoint.sh
# Should show "shell script, ASCII text" not "CRLF"
```

**Most likely fix:** Add this to your Dockerfile after `COPY`:
```dockerfile
RUN chmod +x /app/entrypoint.sh
```

And ensure your script uses LF line endings (not CRLF).
