#!/usr/bin/env node

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";
import errorIndex from "./error-index.json" with { type: "json" };

interface ErrorEntry {
  stack: string;
  filename: string;
  title: string;
  errorMessage: string;
  whatHappened: string;
  whyItHappens: string;
  howToFix: string;
  dontDoThis: string;
  stillNotWorking: string;
  keywords: string[];
}

const errors: ErrorEntry[] = errorIndex as ErrorEntry[];

// Common words that should not count toward relevance
const STOP_WORDS = new Set([
  "error", "failed", "fail", "not", "found", "cannot", "can",
  "the", "this", "that", "with", "from", "for", "how", "why",
  "what", "does", "when", "after", "before", "using", "use",
  "get", "got", "set", "has", "have", "been", "being", "was",
  "are", "but", "and", "the", "into", "out", "its", "you",
  "your", "check", "need", "needed", "instead", "even",
  "should", "could", "would", "make", "sure", "try",
]);

function searchErrors(query: string, stack?: string, limit = 5): ErrorEntry[] {
  const queryLower = query.toLowerCase();
  const queryWords = queryLower
    .replace(/[^a-z0-9_\-.:/ ]/g, " ")
    .split(/\s+/)
    .filter((w) => w.length > 2 && !STOP_WORDS.has(w));

  const scored = errors
    .filter((e) => !stack || e.stack === stack.toLowerCase())
    .map((entry) => {
      let score = 0;
      let hasStrongMatch = false;

      // Exact substring match in error message (highest value)
      if (entry.errorMessage.toLowerCase().includes(queryLower)) {
        score += 100;
        hasStrongMatch = true;
      }

      // Exact substring match in title
      if (entry.title.toLowerCase().includes(queryLower)) {
        score += 50;
        hasStrongMatch = true;
      }

      // Word-level matches in keywords (only non-stop words)
      let keywordMatches = 0;
      for (const word of queryWords) {
        if (entry.keywords.some((k) => k.includes(word))) {
          score += 10;
          keywordMatches++;
        }
        if (entry.errorMessage.toLowerCase().includes(word)) {
          score += 5;
          keywordMatches++;
        }
      }

      // A match is "strong" only if:
      // - Full query is a substring of the error message or title (exact match), OR
      // - At least 60% of meaningful query words appear in the entry
      if (queryWords.length > 0 && keywordMatches >= queryWords.length * 0.6) {
        hasStrongMatch = true;
      }

      // Minimum absolute score threshold
      if (score < 40) {
        hasStrongMatch = false;
      }

      // Stack match bonus
      if (stack && entry.stack === stack.toLowerCase()) {
        score += 20;
      }

      return { entry, score, hasStrongMatch };
    })
    // Only return results with a strong match (not just noise)
    .filter((s) => s.score > 0 && s.hasStrongMatch)
    .sort((a, b) => b.score - a.score)
    .slice(0, limit);

  return scored.map((s) => s.entry);
}

function formatEntry(entry: ErrorEntry): string {
  let result = `# ${entry.title}\n\n`;
  result += `**Stack:** ${entry.stack}\n\n`;
  result += `> ${entry.errorMessage}\n\n`;

  if (entry.whatHappened) {
    result += `## What happened\n${entry.whatHappened}\n\n`;
  }
  if (entry.whyItHappens) {
    result += `## Why it happens\n${entry.whyItHappens}\n\n`;
  }
  if (entry.howToFix) {
    result += `## How to fix it\n${entry.howToFix}\n\n`;
  }
  if (entry.stillNotWorking) {
    result += `## Still not working?\n${entry.stillNotWorking}\n\n`;
  }

  return result.trim();
}

const server = new McpServer({
  name: "error-messages-decoded",
  version: "1.0.0",
});

server.tool(
  "decode_error",
  "Search the error knowledge base for a specific error message. Returns the root cause, fix, and anti-patterns to avoid. Works best when you paste the exact error message.",
  {
    error_message: z
      .string()
      .describe(
        "The error message to decode. Can be the full error or a key part of it."
      ),
    stack: z
      .string()
      .optional()
      .describe(
        "Optional: filter by stack (node, npm, python, pip, typescript, react, docker, kubernetes, git, postgres, redis, nginx, linux, ssh, aws, go, rust, webpack, eslint)"
      ),
    limit: z
      .number()
      .optional()
      .default(3)
      .describe("Max number of results to return (default: 3)"),
  },
  async ({ error_message, stack, limit }) => {
    const results = searchErrors(error_message, stack, limit);

    if (results.length === 0) {
      return {
        content: [
          {
            type: "text" as const,
            text: `No matching errors found for: "${error_message}"${stack ? ` in stack: ${stack}` : ""}.\n\nThis error is not in the knowledge base yet. You can contribute it at: https://github.com/andreahlert/error-messages-decoded`,
          },
        ],
      };
    }

    const formatted = results.map(formatEntry).join("\n\n---\n\n");

    return {
      content: [
        {
          type: "text" as const,
          text: `Found ${results.length} matching error(s):\n\n${formatted}`,
        },
      ],
    };
  }
);

server.tool(
  "list_stacks",
  "List all available stacks/technologies in the error knowledge base with error counts.",
  {},
  async () => {
    const stackCounts = new Map<string, number>();
    for (const entry of errors) {
      stackCounts.set(entry.stack, (stackCounts.get(entry.stack) || 0) + 1);
    }

    const lines = [...stackCounts.entries()]
      .sort((a, b) => b[1] - a[1])
      .map(([stack, count]) => `- **${stack}**: ${count} errors`);

    return {
      content: [
        {
          type: "text" as const,
          text: `Error knowledge base contains ${errors.length} errors across ${stackCounts.size} stacks:\n\n${lines.join("\n")}`,
        },
      ],
    };
  }
);

server.tool(
  "list_errors",
  "List all known errors for a specific stack/technology.",
  {
    stack: z
      .string()
      .describe(
        "The stack to list errors for (e.g., node, docker, python, kubernetes)"
      ),
  },
  async ({ stack }) => {
    const stackErrors = errors.filter(
      (e) => e.stack === stack.toLowerCase()
    );

    if (stackErrors.length === 0) {
      return {
        content: [
          {
            type: "text" as const,
            text: `No errors found for stack: "${stack}". Use list_stacks to see available stacks.`,
          },
        ],
      };
    }

    const lines = stackErrors.map(
      (e) => `- **${e.title}**: \`${e.errorMessage.split("\n")[0]}\``
    );

    return {
      content: [
        {
          type: "text" as const,
          text: `${stackErrors.length} known errors for **${stack}**:\n\n${lines.join("\n")}`,
        },
      ],
    };
  }
);

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
