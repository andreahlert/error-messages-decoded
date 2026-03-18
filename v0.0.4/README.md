# v0.0.4 - Real Stack Overflow errors (search problem found)

**Date:** 2026-03-18
**Cases:** 20 real SO questions (10 covered, 10 not covered by MCP base)
**Method:** Binary regex, gabarito from SO accepted answers
**Models:** Haiku, qwen2.5:1.5b, qwen2.5:1.5b+MCP

## Result

| | Haiku | qwen | qwen+MCP |
|---|---|---|---|
| Correct | 18/20 | 18/20 | **15/20** |

## What we learned

- **MCP made things worse** (18→15)
- Root cause: MCP search returned irrelevant matches (Java question got AWS answer, C# question got Nginx answer)
- Small model (1.5b) follows irrelevant context blindly instead of ignoring it
- **Fix needed:** Better search with minimum relevance threshold
