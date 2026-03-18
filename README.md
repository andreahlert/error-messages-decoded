# error-messages-decoded

Research: Can a curated error knowledge base (MCP) make a free local model match a paid API model for error diagnosis?

## Status

| Version | Cases | Method | Key Finding |
|---------|-------|--------|-------------|
| [v0.0.1](v0.0.1/) | 20 easy | LLM judge | Judge is useless, easy errors don't differentiate |
| [v0.0.2](v0.0.2/) | 20 nightmare | Binary regex | 7b+MCP matched Haiku (20/20), but biased eval |
| [v0.0.3](v0.0.3/) | 100 nightmare | Binary regex | 98/100 for both 1.5b+MCP and Haiku, still biased |
| [v0.0.4](v0.0.4/) | 20 real (SO) | Binary regex | MCP worsened results (15/20) due to bad search |
| [v0.0.5](v0.0.5/) | 20 real (SO) | Binary regex | Search threshold helped (16/20) but "no match" message hurt |
| [v0.0.6](v0.0.6/) | 20 real (SO) | Binary regex | Silent MCP: matched Haiku (18/20), 100% on hits |

See [RESULTS.md](RESULTS.md) for the full evolution.

## Components

- **errors/** - Curated error knowledge base (249 errors, 28 stacks)
- **mcp-server/** - MCP server with `decode_error`, `list_stacks`, `list_errors` tools
- **v0.0.X/** - Versioned experiments with datasets, baselines, and results
- **lint.sh** - Validates error file format

## Key Discoveries

1. **MCP must be silent when it doesn't know.** Injecting "no match found" makes small models worse.
2. **Search quality matters more than knowledge base size.** Bad matches poison small model responses.
3. **"Don't do this" sections confuse small models.** They interpret warnings as instructions.
4. **Easy errors don't prove anything.** A 1.5B model already knows most common errors.
5. **Biased evals give inflated numbers.** Creating test cases and answers together yields 98% that means nothing.

## License

AGPL-3.0 - See [LICENSE](LICENSE)
