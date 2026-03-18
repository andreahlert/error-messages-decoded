# v0.0.1 - LLM Judge (failed approach)

**Date:** 2026-03-17
**Cases:** 20 basic errors
**Method:** LLM judge scores 1-5
**Models:** Haiku vs Sonnet (with and without MCP)

## Result

| | Haiku | Haiku + MCP |
|---|---|---|
| Score | 4.81/5 | 4.74/5 |

## What we learned

- LLM judge is subjective and format-sensitive
- Easy errors don't differentiate models
- MCP had no measurable impact on common errors
- **Conclusion:** Wrong methodology. Need harder cases and objective scoring.
