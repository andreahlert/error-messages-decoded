# v0.0.3 - Scaled to 100 nightmare cases

**Date:** 2026-03-17
**Cases:** 100 nightmare errors across 28 stacks
**Method:** Binary regex scoring, five-way comparison
**Models:** qwen2.5:1.5b, qwen2.5:1.5b+MCP, qwen2.5:7b, qwen2.5:7b+MCP, Haiku

## Result

| | 1.5b | 1.5b+MCP | 7b | 7b+MCP | Haiku |
|---|---|---|---|---|---|
| Correct | 81/100 | **98/100** | 90/100 | **98/100** | **98/100** |
| Safe | 84/100 | **87/100** | 83/100 | **85/100** | 76/100 |

## What we learned

- MCP gave +17 correct answers to 1.5b model
- Both 1.5b+MCP and 7b+MCP matched Haiku at 98/100
- **Bias still present:** test cases and base created by same process
- **Validation needed:** real-world errors from independent source
