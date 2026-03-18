# v0.0.7 - Harder Stack Overflow errors

**Date:** 2026-03-18
**Cases:** 20 harder SO questions (misleading errors, Rust, C, C++, Go)
**Method:** Binary regex, gabarito from SO accepted answers, silent MCP
**Models:** Haiku, qwen2.5:1.5b, qwen2.5:1.5b+MCP
**Base:** Frozen at 249 entries (not modified for these tests)

## Result

| | Haiku | qwen 1.5b | qwen+MCP |
|---|---|---|---|
| Correct | **20/20** | 17/20 | **18/20** |
| Safe | 18/20 | 19/20 | **20/20** |

## MCP impact

- Case 1 (ENOSPC): qwen didn't know it's inotify. **MCP corrected it.**
- Case 2 (shebang): both failed. MCP matched wrong variant.
- Case 8 (OpenSSL): MCP had the answer but 1.5b model couldn't extract `--openssl-legacy-provider` from context.
- Not-covered cases (9): MCP stayed silent, no harm done.
