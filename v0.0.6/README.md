# v0.0.6 - Silent MCP when no match

**Date:** 2026-03-18
**Cases:** Same 20 real SO questions
**Method:** Binary regex, same gabarito
**Models:** Haiku, qwen2.5:1.5b, qwen2.5:1.5b+MCP
**Change:** When MCP has no match, model gets identical prompt as baseline (no noise)

## Result

| | Haiku | qwen | qwen+MCP |
|---|---|---|---|
| Correct | **18/20** | **18/20** | **18/20** |
| Safe | 18/20 | **19/20** | **19/20** |

### By coverage

| | Haiku | qwen | qwen+MCP |
|---|---|---|---|
| Covered (10) | 8/10 | 8/10 | **9/10** |
| Not covered (10) | 10/10 | 10/10 | 9/10 |

### MCP hit impact

| MCP had match? | qwen+MCP |
|---|---|
| Yes (4 cases) | **4/4 (100%)** |
| No (16 cases) | 14/16 |

## What we learned

- qwen+MCP now matches Haiku (18/20 = 18/20)
- When MCP has a match: 100% correct (4/4)
- When MCP has no match: doesn't hurt (same prompt as baseline)
- MCP saved 1 case that qwen missed alone (docker permission denied)
- **Problem remaining:** errors are too easy. qwen 1.5b already scores 18/20 alone.
- **Next:** Need harder real-world errors to show MCP value.
