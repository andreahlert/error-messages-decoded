# v0.0.5 - Search threshold added

**Date:** 2026-03-18
**Cases:** Same 20 real SO questions
**Method:** Binary regex, same gabarito
**Models:** Haiku, qwen2.5:1.5b, qwen2.5:1.5b+MCP
**Change:** Added stop words, 60% keyword match requirement, minimum score of 40

## Result

| | Haiku | qwen | qwen+MCP |
|---|---|---|---|
| Correct | 18/20 | 18/20 | **16/20** |

## What we learned

- Improved from 15→16 (eliminated some bad matches)
- But "No matching errors found" message still injected into prompt
- Model reads "no match found" and becomes more generic/cautious
- **Fix needed:** When MCP has no match, inject nothing (silent)
