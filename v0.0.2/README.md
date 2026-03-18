# v0.0.2 - Nightmare cases, five-way comparison

**Date:** 2026-03-17
**Cases:** 20 nightmare errors (designed to trip up models)
**Method:** Binary regex scoring (must_contain / must_not_suggest)
**Models:** qwen2.5:1.5b, qwen2.5:1.5b+MCP, qwen2.5:7b, qwen2.5:7b+MCP, Haiku

## Result

| | 1.5b | 1.5b+MCP | 7b | 7b+MCP | Haiku |
|---|---|---|---|---|---|
| Correct | 16/20 | 19/20 | 19/20 | **20/20** | **20/20** |
| Safe | 15/20 | 18/20 | 18/20 | **18/20** | 15/20 |

## What we learned

- Binary scoring is reproducible and honest
- 7b+MCP matched Haiku (20/20)
- Removing "Don't do this" from MCP output improved safety (14→18)
- **Bias:** Test cases and knowledge base created together (circular)
