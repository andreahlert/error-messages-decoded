# v0.0.9 - Embeddings + Soft Prompt

**Date:** 2026-03-19
**Cases:** 100 real SO questions (same as v0.0.8)
**Method:** Semantic search (all-MiniLM-L6-v2), cosine similarity threshold 0.55, soft prompt
**Models:** Haiku, qwen2.5:1.5b, qwen2.5:1.5b+MCP
**Infrastructure:** Flyte workflow (pyflyte run local)

## Changes from v0.0.8

1. **Embeddings** replaced keyword search. 22MB model (all-MiniLM-L6-v2) encodes error messages and compares by cosine similarity.
2. **Threshold 0.55** instead of keyword matching. Only 29/100 cases get MCP context (vs 70/100 in v0.0.8).
3. **Soft prompt**: "Here is a possibly related error. Only use this if the error message closely matches yours. If it does not match, ignore it completely."

## Result

| | Haiku | qwen 1.5b | qwen+MCP |
|---|---|---|---|
| Correct | **90/100** | 68/100 | **70/100** |
| Safe | 99/100 | 99/100 | 98/100 |

## vs v0.0.8

| | v0.0.8 | v0.0.9 |
|---|---|---|
| qwen+MCP | 65/100 | **70/100** |
| MCP delta | +0 | **+2** |
| MCP matches | 70/100 | 29/100 |
| MCP helped | 8 | 9 |
| MCP hurt | 8 | 7 |

Fewer matches, higher precision, net positive.
