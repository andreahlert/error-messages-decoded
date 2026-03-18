# Results Evolution

## The journey from 98% (fake) to 18/20 (real)

### v0.0.1: Wrong methodology

Used an LLM to judge another LLM's response on a 1-5 scale. The judge was format-sensitive and inconsistent. Haiku scored 4.81 without MCP and 4.74 with MCP. Learned nothing.

### v0.0.2: Right methodology, wrong data

Switched to binary regex scoring: does the response contain the correct fix? Tested with 20 "nightmare" cases we designed. Found that removing "Don't do this" from MCP output improved safety from 14/20 to 18/20. First real insight.

But the test cases and knowledge base were created together. Circular.

### v0.0.3: Scale doesn't fix bias

Expanded to 100 nightmare cases. Got 98/100 for both 1.5b+MCP and Haiku. Impressive number, but the eval was testing whether the model could find in the MCP base what we put there for it to find. Of course it could.

### v0.0.4: Reality check

Used 20 real questions from Stack Overflow. Gabarito extracted from human-written accepted answers. No consulting our knowledge base.

MCP made things **worse**: 15/20 vs 18/20 without it.

Root cause: the MCP search returned irrelevant matches. A question about Java instanceof got an answer about AWS IAM. A question about C# casting got an answer about Nginx SSL. The 1.5B model followed the irrelevant context instead of using its own (correct) knowledge.

### v0.0.5: Search quality matters

Added stop words, minimum keyword match (60%), and score threshold (40). Eliminated the worst false positives. Improved from 15/20 to 16/20.

But the "No matching errors found" message injected when the MCP had no answer was making the model more cautious and generic.

### v0.0.6: Silence is better than noise

When MCP has no match, inject nothing. Model gets the exact same prompt as baseline. No noise.

Result: **18/20 for all three** (Haiku, qwen alone, qwen+MCP). When MCP had a match (4 cases), it was 100% correct. When it didn't (16 cases), it didn't hurt.

The MCP saved 1 case that qwen missed (docker permission denied: 8→9 in covered cases).

## Current state

The test cases are too easy. A 1.5B model scores 18/20 on popular Stack Overflow questions without any help. We need harder real-world errors to demonstrate MCP value.

## Summary table

| Version | qwen 1.5b | qwen+MCP | Haiku | What changed |
|---------|-----------|----------|-------|-------------|
| v0.0.2 | 16/20 | 19/20 | 20/20 | Nightmare cases (biased) |
| v0.0.3 | 81/100 | 98/100 | 98/100 | 100 cases (biased) |
| v0.0.4 | 18/20 | **15/20** | 18/20 | Real SO errors, bad search |
| v0.0.5 | 18/20 | **16/20** | 18/20 | Search threshold |
| v0.0.6 | 18/20 | **18/20** | 18/20 | Silent MCP |
