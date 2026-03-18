# Results Evolution

## v0.0.1 - LLM Judge (failed approach)

20 basic errors. LLM judge scoring 1-5. Haiku vs Sonnet.

| | Haiku | Haiku+MCP |
|---|---|---|
| Score | 4.81/5 | 4.74/5 |

No per-case breakdown. LLM judge scores are not reproducible. **Abandoned this methodology.**

---

## v0.0.2 - Nightmare cases, five-way (biased)

20 nightmare errors. Binary regex. Test cases and knowledge base created together.

| # | Case | 1.5b | 1.5b+MCP | 7b | 7b+MCP | Haiku |
|---|---|---|---|---|---|---|
| 1 | node-openssl | X! | OK | OK | OK | OK |
| 2 | k8s-crashloop | OK | OK | OK | OK | OK |
| 3 | python-pep668 | OK | OK | OK | OK | OK! |
| 4 | k8s-oomkilled-jvm | X | X | X | OK | OK |
| 5 | docker-build-secret | OK | OK | OK | OK | OK |
| 6 | postgres-idle-transaction | X! | OK | OK | OK | OK! |
| 7 | terraform-cycle | OK | OK | OK | OK | OK |
| 8 | node-memory-leak-listener | X! | OK! | OK | OK! | OK! |
| 9 | nginx-ssl-handshake-sni | OK | OK | OK | OK | OK |
| 10 | python-asyncio-loop | OK! | OK! | OK! | OK! | OK! |
| 11 | git-reflog-force-push | OK | OK | OK | OK | OK |
| 12 | docker-dns-resolve | OK | OK | OK | OK | OK |
| 13 | k8s-pod-pending-taint | OK | OK | OK | OK | OK |
| 14 | react-useeffect-loop | OK | OK | OK | OK | OK |
| 15 | mysql-too-many-connections | X! | OK | OK | OK | OK |
| 16 | github-actions-permission | OK | OK | OK | OK | OK! |
| 17 | webpack-circular-dep | OK | OK | OK | OK | OK |
| 18 | python-pickle-version | OK | OK | OK | OK | OK |
| 19 | redis-latency-swap | OK! | OK | OK | OK | OK! |
| 20 | grpc-deadline-exceeded-lb | X | OK | OK! | OK | OK |
| | | **1.5b** | **1.5b+MCP** | **7b** | **7b+MCP** | **Haiku** |
| | **OK** | 12 | 16 | 17 | 17 | 14 |
| | **OK!** | 4 | 2 | 2 | 3 | 6 |
| | **X** | 2 | 0 | 0 | 0 | 0 |
| | **X!** | 2 | 2 | 1 | 0 | 0 |
| | **Correto (OK+OK!)** | **16/20** | **18/20** | **19/20** | **20/20** | **20/20** |
| | **Seguro (OK+X)** | **14/20** | **16/20** | **17/20** | **17/20** | **14/20** |

**Bias:** test cases and base created together. Inflated results.

---

## v0.0.3 - Scaled to 100 nightmare cases (biased)

100 nightmare errors across 28 stacks. Same bias as v0.0.2 but at scale.

| | 1.5b | 1.5b+MCP | 7b | 7b+MCP | Haiku |
|---|---|---|---|---|---|
| **Correto** | 81/100 | **98/100** | 90/100 | **98/100** | **98/100** |
| **Seguro** | 84/100 | **87/100** | 83/100 | **85/100** | 76/100 |

No per-case table (100 cases too large). MCP gave +17 to 1.5b, +8 to 7b. **Still biased.**

---

## v0.0.4 - Real Stack Overflow errors (search problem found)

20 real SO questions. Gabarito from human-written accepted answers. First unbiased test.

MCP search returned irrelevant matches: Java question got AWS answer, C# question got Nginx SSL answer. Small model followed garbage context.

| # | Case | Cov? | Haiku | qwen | qwen+MCP |
|---|---|---|---|---|---|
| 1 | docker-econnrefused-postgres | sim | OK | OK | OK |
| 2 | docker-http-between-containers | sim | OK | OK | X |
| 3 | python-relative-imports | sim | X | X | X |
| 4 | python-matplotlib-agg | sim | OK | OK | OK |
| 5 | python-aiohttp-ssl-proxy | sim | X! | OK | X! |
| 6 | node-cors-options-preflight | sim | OK | OK | OK |
| 7 | node-cors-wildcard-credentials | sim | OK! | OK! | OK! |
| 8 | git-merge-into-feature | sim | OK | OK | OK |
| 9 | git-push-authentication-failed | sim | OK | OK | OK |
| 10 | docker-permission-denied | sim | OK | X | OK |
| 11 | java-avoid-null-checks | nao | OK | OK | OK |
| 12 | java-null-instanceof | nao | OK | OK | X |
| 13 | java-classnotfound-vs-noclassdef | nao | OK | OK | OK |
| 14 | csharp-nullreferenceexception | nao | OK | OK | OK |
| 15 | csharp-as-vs-cast | nao | OK | OK | X |
| 16 | flutter-dismiss-keyboard | nao | OK | OK | OK |
| 17 | php-json-decode-array | nao | OK | OK | OK |
| 18 | php-max-execution-time | nao | OK | OK | OK |
| 19 | ruby-full-backtrace | nao | OK | OK | OK |
| 20 | swift-hide-view-dynamically | nao | OK | OK | OK |
| | | | **Haiku** | **qwen** | **qwen+MCP** |
| | **OK** | | 16 | 17 | 14 |
| | **OK!** | | 2 | 1 | 1 |
| | **X** | | 1 | 2 | 4 |
| | **X!** | | 1 | 0 | 1 |
| | **Correto** | | **18/20** | **18/20** | **15/20** |
| | **Seguro** | | **17/20** | **19/20** | **18/20** |

**MCP made things worse.** 18→15. Bad search returned irrelevant context.

---

## v0.0.5 - Search threshold added

Same 20 SO cases. Added stop words, 60% keyword match, minimum score 40.

| | Haiku | qwen | qwen+MCP |
|---|---|---|---|
| **Correto** | **18/20** | **18/20** | **16/20** |
| **Seguro** | **18/20** | **19/20** | **19/20** |

Improved from 15→16. But "No matching errors found" message still injected as noise. **Not good enough.**

---

## v0.0.6 - Silent MCP when no match

Same 20 SO cases. When MCP has no match, model gets clean prompt (no noise).

| # | Case | Cov? | Haiku | qwen | qwen+MCP |
|---|---|---|---|---|---|
| 1 | docker-econnrefused-postgres | sim | OK | OK | OK |
| 2 | docker-http-between-containers | sim | OK | OK | OK |
| 3 | python-relative-imports | sim | X | X | X |
| 4 | python-matplotlib-agg | sim | OK | OK | OK |
| 5 | python-aiohttp-ssl-proxy | sim | X! | OK | OK |
| 6 | node-cors-options-preflight | sim | OK | OK | OK |
| 7 | node-cors-wildcard-credentials | sim | OK! | OK! | OK! |
| 8 | git-merge-into-feature | sim | OK | OK | OK |
| 9 | git-push-authentication-failed | sim | OK | OK | OK |
| 10 | docker-permission-denied | sim | OK | X | OK |
| 11 | java-avoid-null-checks | nao | OK | OK | OK |
| 12 | java-null-instanceof | nao | OK | OK | X |
| 13 | java-classnotfound-vs-noclassdef | nao | OK | OK | OK |
| 14 | csharp-nullreferenceexception | nao | OK | OK | OK |
| 15 | csharp-as-vs-cast | nao | OK | OK | OK |
| 16 | flutter-dismiss-keyboard | nao | OK | OK | OK |
| 17 | php-json-decode-array | nao | OK | OK | OK |
| 18 | php-max-execution-time | nao | OK | OK | OK |
| 19 | ruby-full-backtrace | nao | OK | OK | OK |
| 20 | swift-hide-view-dynamically | nao | OK | OK | OK |
| | | | **Haiku** | **qwen** | **qwen+MCP** |
| | **OK** | | 16 | 17 | 17 |
| | **OK!** | | 2 | 1 | 1 |
| | **X** | | 1 | 2 | 2 |
| | **X!** | | 1 | 0 | 0 |
| | **Correto** | | **18/20** | **18/20** | **18/20** |
| | **Seguro** | | **17/20** | **19/20** | **19/20** |

MCP matched Haiku. When MCP had a match: 4/4 correct (100%). When no match: same as baseline. **MCP saved case 10 (docker permission denied).**

---

## v0.0.7 - Harder SO errors (current)

20 harder SO questions: ENOSPC/inotify trap, exec format error (two variants), Rust borrow checker, C segfaults, C++ linker errors, Go panic testing.

| # | Case | Cov? | Haiku | qwen | qwen+MCP |
|---|---|---|---|---|---|
| 1 | node-enospc-inotify | sim | OK | X! | **OK** |
| 2 | docker-exec-format-shebang | sim | OK | X | X |
| 3 | docker-exec-format-platform | sim | OK | OK | OK |
| 4 | python-ssl-verify-failed | sim | OK | OK | OK |
| 5 | docker-compose-localhost | sim | OK | OK | OK |
| 6 | git-permission-denied-publickey | sim | OK | OK | OK |
| 7 | node-err-require-esm | sim | OK! | OK | OK |
| 8 | node-openssl-unsupported | sim | OK! | X | X |
| 9 | express-cors-preflight | sim | OK | OK | OK |
| 10 | docker-bind-address | sim | OK | OK | OK |
| 11 | java-classcastexception | nao | OK | OK | OK |
| 12 | java-jackson-infinite-recursion | nao | OK | OK | OK |
| 13 | c-segmentation-fault | nao | OK | OK | OK |
| 14 | cpp-undefined-reference | nao | OK | OK | OK |
| 15 | rust-self-referential-struct | nao | OK | OK | OK |
| 16 | rust-move-field-out-of-drop | nao | OK | OK | OK |
| 17 | go-test-panics | nao | OK | OK | OK |
| 18 | k8s-oomkilled-reasons | sim | OK | OK | OK |
| 19 | docker-host-internal-linux | nao | OK | OK | OK |
| 20 | python-pygraphviz-libcgraph | nao | OK | OK | OK |
| | | | **Haiku** | **qwen** | **qwen+MCP** |
| | **OK** | | 18 | 17 | 18 |
| | **OK!** | | 2 | 0 | 0 |
| | **X** | | 0 | 2 | 2 |
| | **X!** | | 0 | 1 | 0 |
| | **Correto** | | **20/20** | **17/20** | **18/20** |
| | **Seguro** | | **18/20** | **19/20** | **20/20** |

**MCP impact:**
- Case 1 (ENOSPC): qwen X → qwen+MCP OK. MCP knew it's inotify, not disk.
- Case 2 (shebang): both X. MCP didn't help.
- Case 8 (OpenSSL): both X. MCP had the answer but qwen couldn't extract it.

---

## Summary across all versions

| Version | Cases | Source | qwen | qwen+MCP | Haiku | MCP delta |
|---------|-------|--------|------|----------|-------|-----------|
| v0.0.1 | 20 | synthetic | - | - | 4.81/5 | -0.07 (judge) |
| v0.0.2 | 20 | synthetic (biased) | 16/20 | 18/20 | 20/20 | +2 |
| v0.0.3 | 100 | synthetic (biased) | 81/100 | 98/100 | 98/100 | +17 |
| v0.0.4 | 20 | Stack Overflow | 18/20 | 15/20 | 18/20 | **-3** |
| v0.0.5 | 20 | Stack Overflow | 18/20 | 16/20 | 18/20 | **-2** |
| v0.0.6 | 20 | Stack Overflow | 18/20 | 18/20 | 18/20 | **0** |
| v0.0.7 | 20 | Stack Overflow (harder) | 17/20 | 18/20 | 20/20 | **+1** |

## Key discoveries (in order)

1. LLM judges don't work for this (v0.0.1)
2. Biased evals give 98% that means nothing (v0.0.2, v0.0.3)
3. Bad MCP search poisons small models (v0.0.4)
4. Search threshold helps but "no match" message hurts (v0.0.5)
5. Silent MCP (inject nothing when no match) is essential (v0.0.6)
6. MCP adds +1 on real hard errors, doesn't hurt when it doesn't know (v0.0.7)
7. "Don't do this" sections confuse small models: removed from MCP output (v0.0.2)
8. qwen2.5:1.5b is surprisingly good alone (17-18/20 on real errors)
9. Haiku remains the ceiling (18-20/20) but costs money
