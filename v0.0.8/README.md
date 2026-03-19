# v0.0.8 - 100 Real SO Cases, Keyword Search

**Date:** 2026-03-18
**Cases:** 100 real SO questions (49 covered, 51 not covered)
**Method:** Keyword search with stack detection, silent MCP, Flyte workflow
**Models:** Haiku, qwen2.5:1.5b, qwen2.5:1.5b+MCP

## Result

| | Haiku | qwen 1.5b | qwen+MCP |
|---|---|---|---|
| Correct | **87/100** | 65/100 | 65/100 |
| Safe | 100/100 | 98/100 | 99/100 |

## MCP impact

- MCP matched 70/100 cases (too many, should be ~49)
- Helped 8, hurt 8, **delta: +0**
- Within-stack false positives: Docker query gets wrong Docker error, model follows wrong advice

## Key finding

Keyword search cannot distinguish between errors within the same stack. 20+ Docker errors in the base means any Docker query matches something. The MCP returns confident-looking but wrong context, and the 1.5B model follows it blindly.
