/**
 * Build script that reads all error markdown files from ../errors/
 * and generates a JSON index at src/error-index.json
 *
 * The index contains parsed error entries with:
 * - stack (e.g., "node", "docker", "python")
 * - filename
 * - title
 * - errorMessage (from the blockquote)
 * - whatHappened
 * - whyItHappens
 * - howToFix
 * - dontDoThis
 * - stillNotWorking
 * - keywords (extracted from title + error message for search)
 */

import { readFileSync, readdirSync, writeFileSync, statSync } from "fs";
import { join, basename } from "path";

const ERRORS_DIR = join(import.meta.dirname, "..", "..", "errors");
const OUTPUT_FILE = join(import.meta.dirname, "..", "src", "error-index.json");

function extractSection(content, heading) {
  const regex = new RegExp(
    `^## ${heading}\\s*\\n([\\s\\S]*?)(?=^## |$)`,
    "mi"
  );
  const match = content.match(regex);
  return match ? match[1].trim() : "";
}

function extractBlockquote(content) {
  const lines = content.split("\n");
  const quoteLines = [];
  let inQuote = false;

  for (const line of lines) {
    if (line.startsWith("> ")) {
      inQuote = true;
      quoteLines.push(line.slice(2));
    } else if (inQuote && line.startsWith(">")) {
      quoteLines.push(line.slice(1).trim());
    } else if (inQuote) {
      break;
    }
  }

  return quoteLines.join("\n").trim();
}

function extractTitle(content) {
  const match = content.match(/^# (.+)/m);
  return match ? match[1].trim() : "";
}

function generateKeywords(title, errorMessage, stack) {
  const text = `${title} ${errorMessage} ${stack}`.toLowerCase();
  const words = text
    .replace(/[^a-z0-9_\-.:/ ]/g, " ")
    .split(/\s+/)
    .filter((w) => w.length > 2);
  return [...new Set(words)];
}

function parseErrorFile(filePath, stack) {
  const content = readFileSync(filePath, "utf-8");
  const title = extractTitle(content);
  const errorMessage = extractBlockquote(content);

  return {
    stack,
    filename: basename(filePath, ".md"),
    title,
    errorMessage,
    whatHappened: extractSection(content, "What happened"),
    whyItHappens: extractSection(content, "Why it happens"),
    howToFix: extractSection(content, "How to fix it"),
    dontDoThis: extractSection(content, "Don't do this"),
    stillNotWorking: extractSection(content, "Still not working\\?"),
    keywords: generateKeywords(title, errorMessage, stack),
  };
}

function buildIndex() {
  const index = [];

  const stacks = readdirSync(ERRORS_DIR).filter((f) => {
    return statSync(join(ERRORS_DIR, f)).isDirectory();
  });

  for (const stack of stacks) {
    const stackDir = join(ERRORS_DIR, stack);
    const files = readdirSync(stackDir).filter((f) => f.endsWith(".md"));

    for (const file of files) {
      try {
        const entry = parseErrorFile(join(stackDir, file), stack);
        if (entry.title && entry.errorMessage) {
          index.push(entry);
        }
      } catch (e) {
        console.error(`Warning: failed to parse ${stack}/${file}: ${e.message}`);
      }
    }
  }

  writeFileSync(OUTPUT_FILE, JSON.stringify(index, null, 2));
  console.log(`Built index with ${index.length} errors from ${stacks.length} stacks`);
}

buildIndex();
