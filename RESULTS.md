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

## v0.0.7 - Harder SO errors

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

## v0.0.8 - 100 real SO cases, keyword search (Flyte workflow)

100 cases from Stack Overflow. 49 covered by the knowledge base, 51 not covered. Keyword search within same stack.

| | Haiku | qwen | qwen+MCP |
|---|---|---|---|
| **Correto** | **87/100** | **65/100** | **65/100** |
| **Seguro** | **100/100** | **98/100** | **99/100** |
| **Covered** | 43/49 | 25/49 | 26/49 |
| **Not covered** | 44/51 | 40/51 | 39/51 |

MCP delta: +0 (helped 8, hurt 8). MCP matched 70/100 cases, far too many false positives within covered stacks.

No per-case table (100 cases too large). Key finding: keyword search within the same stack returns wrong errors. MCP context from a wrong Docker error overrides the model's correct knowledge.

---

## v0.0.9 - Embeddings + soft prompt (current)

Three changes from v0.0.8:
1. Semantic search with all-MiniLM-L6-v2 embeddings (cosine similarity threshold 0.55)
2. Softer prompt: "possibly related, ignore if not relevant" instead of "expert knowledge, use it"
3. Stack detection still blocks uncovered stacks

| # | Case | Cov? | Haiku | qwen | qwen+MCP |
|---|---|---|---|---|---|
| 1 | so-node-enospc-inotify | sim | OK | X! | **OK** |
| 2 | so-docker-exec-format-shebang | sim | OK | X | X! |
| 3 | so-docker-exec-format-platform | sim | OK | OK | OK |
| 4 | so-python-ssl-verify-failed | sim | OK | OK | OK |
| 5 | so-docker-compose-localhost-wrong | sim | OK | OK | X |
| 6 | so-git-permission-denied-publickey | sim | OK | OK | OK |
| 7 | so-node-err-require-esm | sim | OK | OK | OK! |
| 8 | so-node-openssl-unsupported | sim | OK! | X | **OK** |
| 9 | so-express-cors-preflight-headers | sim | OK | OK | OK |
| 10 | so-docker-bind-address-in-use | sim | OK | OK | OK |
| 11 | so-java-classcastexception-casting | nao | OK | OK | OK |
| 12 | so-java-jackson-infinite-recursion | nao | OK | OK | OK |
| 13 | so-c-segmentation-fault | nao | OK | OK | OK |
| 14 | so-cpp-undefined-reference | nao | OK | OK | OK |
| 15 | so-rust-self-referential-struct | nao | OK | OK | OK |
| 16 | so-rust-move-field-out-of-drop | nao | OK | OK | OK |
| 17 | so-go-test-panics | nao | OK | OK | OK |
| 18 | so-k8s-oomkilled-reasons | sim | OK | OK | OK |
| 19 | so-docker-host-internal-linux | nao | OK | OK | OK |
| 20 | so-python-pygraphviz-libcgraph | nao | OK | OK | OK |
| 21 | so-docker-compose-timeout-unix-socket | sim | OK | X | X |
| 22 | so-docker-compose-convert-run | sim | OK | OK | OK |
| 23 | so-docker-compose-healthcheck-depends-on | sim | OK | X | X |
| 24 | so-docker-mount-single-file | sim | OK | X | **OK** |
| 25 | so-docker-add-volume-existing | sim | OK | X | X |
| 26 | so-docker-volume-permissions | sim | OK | OK | OK |
| 27 | so-docker-failed-solve-frontend | sim | OK | OK | OK |
| 28 | so-docker-failed-compute-cache-key | sim | OK | OK | OK |
| 29 | so-node-cannot-find-module | sim | OK | OK | OK |
| 30 | so-node-getaddrinfo-enotfound | sim | X | X | X |
| 31 | so-node-render-html-view | sim | OK | OK | OK |
| 32 | so-node-heap-out-of-memory | sim | OK | OK | OK |
| 33 | so-node-options-max-old-space | sim | OK | OK | OK |
| 34 | so-node-unhandled-promise-find | sim | OK | X | X |
| 35 | so-node-unhandled-promise-mocha | sim | OK | OK | OK |
| 36 | so-python-relative-imports | sim | OK | OK | OK |
| 37 | so-python-matplotlib-agg-backend | sim | OK | OK | OK |
| 38 | so-python-no-module-tkinter | sim | OK | X | X |
| 39 | so-python-relative-imports-billionth | sim | OK | OK | OK |
| 40 | so-python-virtualenv-python3 | sim | X | X | X |
| 41 | so-python-max-recursion-depth | sim | OK | OK | OK |
| 42 | so-python-asyncio-periodic | sim | X | OK | OK |
| 43 | so-pg-connection-refused | sim | OK | X | X |
| 44 | so-docker-connect-host-postgres | sim | OK | OK | OK |
| 45 | so-pg-check-status-mac | sim | OK | OK | X |
| 46 | so-pg-deadlocks-update | sim | OK | X | **OK** |
| 47 | so-pg-update-order-by | sim | X | X | X |
| 48 | so-k8s-debug-imagepullbackoff | sim | OK | OK | OK |
| 49 | so-k8s-retry-image-pull | sim | OK | OK | X |
| 50 | so-k8s-crashloopbackoff-no-logs | sim | OK | X | X |
| 51 | so-k8s-view-logs-crashed-pod | sim | OK | X | **OK** |
| 52 | so-react-axios-cors | sim | OK | OK | OK |
| 53 | so-react-cors-blocked-localhost | sim | OK | OK | X |
| 54 | so-nextjs-hydration-failed | sim | OK | X | **OK** |
| 55 | so-nextjs-hydration-suspense | sim | X | X | X |
| 56 | so-ts-type-never-error | sim | OK | OK | OK |
| 57 | so-ts-dynamic-properties | sim | OK | OK | X |
| 58 | so-ts-string-index-any-type | sim | OK | OK | OK |
| 59 | so-java-avoid-null-checks | nao | OK | OK | OK |
| 60 | so-java-null-check-instanceof | nao | OK | X | X |
| 61 | so-spring-autowired-null | nao | OK | OK | OK |
| 62 | so-java-gc-overhead-limit | nao | OK | OK | OK |
| 63 | so-java-object-size | nao | X | X | X |
| 64 | so-java-noclassdef-vs-classnotfound | nao | OK | OK | OK |
| 65 | so-java-checked-exceptions-lambda | nao | OK | X | X |
| 66 | so-java-nosuchmethoderror | nao | OK | OK | OK |
| 67 | so-java-hamcrest-describemismatch | nao | OK | OK | OK |
| 68 | so-csharp-nullreferenceexception | nao | OK | OK | OK |
| 69 | so-csharp-as-vs-cast | nao | OK | OK | OK |
| 70 | so-csharp-open-datareader | nao | OK | X | X |
| 71 | so-csharp-maxjsonlength | nao | OK | OK | OK |
| 72 | so-csharp-generic-enum-constraint | nao | OK | X | **OK** |
| 73 | so-ruby-full-backtrace | nao | OK | OK | OK |
| 74 | so-ruby-try-hash-nil | nao | OK | X | X |
| 75 | so-ruby-private-class-method | nao | OK | X | X |
| 76 | so-php-symbol-reference | nao | X | X | **OK** |
| 77 | so-php-parse-syntax-errors | nao | OK | OK | OK |
| 78 | so-php-html-css-to-pdf | nao | OK | OK | OK |
| 79 | so-php-composer-cannot-allocate-memory | nao | OK | OK | OK |
| 80 | so-php-undefined-variable-index | nao | X | X | X |
| 81 | so-flutter-dismiss-keyboard | nao | OK | OK | X |
| 82 | so-flutter-wrapping-text | nao | OK | OK | OK |
| 83 | so-flutter-add-border-widget | nao | OK | OK | OK |
| 84 | so-flutter-renderflex-overflowed | nao | OK | OK | OK |
| 85 | so-rust-println-test | nao | OK | OK | OK |
| 86 | so-rust-iterator-map-result-err | nao | OK | X | X |
| 87 | so-rust-read-write-files | nao | X | X | X |
| 88 | so-rust-index-string | nao | OK | OK | OK |
| 89 | so-go-check-channel-closed | nao | OK | X | X |
| 90 | so-go-select-all-channels-closed | nao | OK | X | X |
| 91 | so-go-append-not-thread-safe | nao | OK | OK | OK |
| 92 | so-js-invalid-date-detection | nao | OK | OK | OK |
| 93 | so-js-wat-talk-coercion | nao | OK | OK | OK |
| 94 | so-js-circular-structure-json | nao | OK | OK | OK |
| 95 | so-js-request-entity-too-large | nao | OK | OK | X |
| 96 | so-python-empty-list-certain-size | nao | OK | X | **OK** |
| 97 | so-python-two-dimensional-array | nao | X | OK | OK |
| 98 | so-csharp-nullref-uninitialized-object | nao | OK | OK | OK |
| 99 | so-php-undefined-index-post-get | nao | OK | OK | OK |
| 100 | so-php-unexpected-token-syntax | nao | OK | OK | OK |
| | | | **Haiku** | **qwen** | **qwen+MCP** |
| | **OK** | | 89 | 68 | 69 |
| | **OK!** | | 1 | 0 | 1 |
| | **X** | | 10 | 31 | 29 |
| | **X!** | | 0 | 1 | 1 |
| | **Correto** | | **90/100** | **68/100** | **70/100** |
| | **Seguro** | | **99/100** | **99/100** | **98/100** |

MCP delta: +2 (helped 9, hurt 7). MCP matched only 29/100 cases (vs 70/100 in v0.0.8), much more selective.

- Covered: Haiku 44/49, qwen 31/49, qwen+MCP 32/49
- Not covered: Haiku 46/51, qwen 37/51, qwen+MCP 38/51

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
| v0.0.8 | 100 | Stack Overflow (keyword) | 65/100 | 65/100 | 87/100 | **0** |
| v0.0.9 | 100 | Stack Overflow (embeddings) | 68/100 | 70/100 | 90/100 | **+2** |

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
10. Keyword search within same stack returns wrong errors, canceling MCP benefit (v0.0.8)
11. Embeddings reduce matches from 70 to 29 but with much higher precision (v0.0.9)
12. Soft prompt ("possibly related") prevents model from abandoning correct knowledge (v0.0.9)
