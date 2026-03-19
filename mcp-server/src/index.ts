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

// Step 1: Map query keywords to stacks we cover
// If the query is about a stack we don't have, return nothing
const STACK_KEYWORDS: Record<string, string[]> = {
  node: ["node", "nodejs", "node.js", "npm", "express", "next.js", "nextjs", "nestjs"],
  npm: ["npm", "yarn", "pnpm", "package.json"],
  python: ["python", "pip", "django", "flask", "fastapi", "pandas", "numpy", "pytorch", "celery", "alembic", "sqlalchemy"],
  pip: ["pip", "pip3", "pipenv", "poetry"],
  typescript: ["typescript", "tsc", "tsconfig", ".tsx", ".ts"],
  react: ["react", "jsx", "useState", "useEffect", "nextjs", "next.js", "hydration"],
  docker: ["docker", "dockerfile", "docker-compose", "container", "image"],
  kubernetes: ["kubernetes", "k8s", "kubectl", "pod", "deployment", "helm", "ingress"],
  git: ["git", "github", "gitlab", "bitbucket", "commit", "push", "pull", "merge", "rebase"],
  postgres: ["postgres", "postgresql", "psql", "pg_", "pgbouncer"],
  mysql: ["mysql", "mariadb"],
  redis: ["redis"],
  nginx: ["nginx"],
  linux: ["linux", "ubuntu", "debian", "centos", "bash", "chmod", "systemctl"],
  ssh: ["ssh", "sshd", "ssh-keygen"],
  aws: ["aws", "amazon", "lambda", "s3", "ec2", "ecs", "iam", "cloudformation", "rds"],
  go: ["golang", "go ", " go ", "goroutine"],
  rust: ["rust", "cargo", "rustc", "borrow checker"],
  webpack: ["webpack"],
  eslint: ["eslint"],
  terraform: ["terraform", "tfstate"],
  mongodb: ["mongodb", "mongo", "mongoose"],
  elasticsearch: ["elasticsearch", "elastic"],
  grpc: ["grpc", "protobuf"],
};

// Stacks NOT in our base (queries about these should return nothing)
const UNCOVERED_STACKS = [
  "java", "jvm", "spring", "maven", "gradle", "junit", "hibernate",
  "classcastexception", "nullpointerexception", "classnotfoundexception",
  "noclassdeffounderror", "nosuchmethoderror", "outofmemoryerror",
  "stackoverflowerror", "@autowired", "jpa", "jdbc",
  "c#", "csharp", ".net", "dotnet", "asp.net", "entity framework", "linq",
  "nullreferenceexception", "invalidoperationexception", "argumentexception",
  "php", "laravel", "symfony", "composer",
  "fatal error:", "undefined variable", "json_decode",
  "ruby", "rails", "bundler", "gem",
  "nomethoderror", "undefined method",
  "swift", "swiftui", "xcode", "ios",
  "kotlin", "android",
  "flutter", "dart", "widget", "renderflex",
  "scala", "sbt",
  "angular", "vue", "svelte",
  "perl", "haskell", "elixir", "erlang", "clojure",
];

function detectStack(query: string): string | null {
  const q = query.toLowerCase();

  // First check: is this about an uncovered stack?
  for (const kw of UNCOVERED_STACKS) {
    if (q.includes(kw)) return "__uncovered__";
  }

  // Second check: which covered stack does this match?
  for (const [stack, keywords] of Object.entries(STACK_KEYWORDS)) {
    for (const kw of keywords) {
      if (q.includes(kw)) return stack;
    }
  }

  // No stack detected - will search all but with strict matching
  return null;
}

// Step 3: Check for consecutive word phrase match (3+ words)
function hasPhraseMatch(query: string, target: string): boolean {
  // Normalize: remove punctuation, collapse whitespace
  const normalize = (s: string) => s.toLowerCase().replace(/[^a-z0-9_ ]/g, " ").replace(/\s+/g, " ").trim();
  const qWords = normalize(query).split(" ").filter(w => w.length > 1);
  const tLower = normalize(target);

  // Try all consecutive 3-word phrases from the query
  for (let i = 0; i <= qWords.length - 3; i++) {
    const phrase = qWords.slice(i, i + 3).join(" ");
    if (tLower.includes(phrase)) return true;
  }

  // Also try 2-word phrases that are specific (not just stop words)
  const STOP = new Set(["the", "a", "an", "is", "in", "on", "to", "of", "for", "and", "or", "not", "with", "how", "do", "i", "my", "it", "be"]);
  for (let i = 0; i <= qWords.length - 2; i++) {
    const w1 = qWords[i], w2 = qWords[i + 1];
    if (!STOP.has(w1) && !STOP.has(w2)) {
      const phrase = `${w1} ${w2}`;
      if (tLower.includes(phrase)) return true;
    }
  }

  // Single distinctive technical term match (error codes, specific status names)
  for (const w of qWords) {
    if (w.length >= 5 && tLower.includes(w)) {
      // Distinctive technical terms: "enospc", "oomkilled", "crashloopbackoff",
      // "econnrefused", "certificate_verify_failed", "cors", etc.
      return true;
    }
  }

  return false;
}

function searchErrors(query: string, stack?: string, limit = 5): ErrorEntry[] {
  // Step 1: Detect stack from query
  const detectedStack = stack || detectStack(query);

  // If query is about an uncovered stack, return nothing immediately
  if (detectedStack === "__uncovered__") return [];

  // Step 2: Filter to detected stack only (or all if no stack detected)
  const candidates = detectedStack
    ? errors.filter(e => e.stack === detectedStack)
    : errors;

  // If stack detected but no candidates, return nothing
  if (candidates.length === 0) return [];

  const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9_ ]/g, " ").replace(/\s+/g, " ").trim();
  const queryNorm = norm(query);

  const scored = candidates
    .map((entry) => {
      let score = 0;
      const errorMsgNorm = norm(entry.errorMessage);
      const titleNorm = norm(entry.title);

      const phraseInError = hasPhraseMatch(query, entry.errorMessage);
      const phraseInTitle = hasPhraseMatch(query, entry.title);

      // Full query substring match
      if (errorMsgNorm.includes(queryNorm)) score += 100;
      if (titleNorm.includes(queryNorm)) score += 50;

      // Phrase match bonus
      if (phraseInError) score += 40;
      if (phraseInTitle) score += 30;

      // Single keyword matches within the filtered stack
      const qWords = queryNorm.split(" ").filter(w => w.length > 2);
      let kwMatches = 0;
      for (const w of qWords) {
        if (errorMsgNorm.includes(w) || titleNorm.includes(w)) kwMatches++;
      }
      if (qWords.length > 0) score += Math.round((kwMatches / qWords.length) * 20);

      // If NO stack was detected (searching all), require phrase match
      // This prevents cross-stack noise when we can't filter by stack
      if (!detectedStack && !phraseInError && !phraseInTitle) {
        score = 0;
      }

      return { entry, score };
    })
    .filter((s) => s.score > 0)
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
