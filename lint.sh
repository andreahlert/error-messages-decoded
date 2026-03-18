#!/usr/bin/env bash
# Linter for error-messages-decoded
# Validates that all error files follow the standard format.
#
# Format rules:
#   1. First line must be a markdown heading "# ..."
#   2. Must contain a blockquote (>) with the exact error message
#   3. Must contain "## What happened"
#   4. Must contain "## Why it happens"
#   5. Must contain "## How to fix it"
#   6. Must contain at least one code block
#   7. Filename must be lowercase kebab-case

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

ERRORS_DIR="${1:-errors}"
errors=0
warnings=0
checked=0
passed=0

if [ ! -d "$ERRORS_DIR" ]; then
  echo -e "${RED}Error: directory '$ERRORS_DIR' not found${NC}"
  exit 1
fi

for file in $(find "$ERRORS_DIR" -name "*.md" -type f | sort); do
  [ -f "$file" ] || continue
  checked=$((checked + 1))
  relpath=$(echo "$file" | sed "s|^$ERRORS_DIR/||")
  file_errors=0

  # Rule 1: Filename must be lowercase kebab-case
  basename_file=$(basename "$file")
  if ! echo "$basename_file" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*\.md$'; then
    echo -e "${RED}FAIL${NC} $relpath: filename must be lowercase kebab-case"
    file_errors=$((file_errors + 1))
  fi

  # Rule 2: First line must be a heading
  first_line=$(head -n 1 "$file")
  if ! echo "$first_line" | grep -qE '^# .+'; then
    echo -e "${RED}FAIL${NC} $relpath: first line must be a markdown heading (# ...)"
    file_errors=$((file_errors + 1))
  fi

  # Rule 3: Must contain a blockquote with the error message
  if ! grep -q '^>' "$file"; then
    echo -e "${RED}FAIL${NC} $relpath: missing blockquote (>) with exact error message"
    file_errors=$((file_errors + 1))
  fi

  # Rule 4: Must contain "## What happened"
  if ! grep -qi '^## What happened' "$file"; then
    echo -e "${RED}FAIL${NC} $relpath: missing '## What happened' section"
    file_errors=$((file_errors + 1))
  fi

  # Rule 5: Must contain "## Why it happens"
  if ! grep -qi '^## Why it happens' "$file"; then
    echo -e "${RED}FAIL${NC} $relpath: missing '## Why it happens' section"
    file_errors=$((file_errors + 1))
  fi

  # Rule 6: Must contain "## How to fix it"
  if ! grep -qi '^## How to fix it' "$file"; then
    echo -e "${RED}FAIL${NC} $relpath: missing '## How to fix it' section"
    file_errors=$((file_errors + 1))
  fi

  # Rule 7: Must contain at least one code block
  if ! grep -q '```' "$file"; then
    echo -e "${RED}FAIL${NC} $relpath: missing code block with fix"
    file_errors=$((file_errors + 1))
  fi

  # Warning: Should contain "## Don't do this"
  if ! grep -qi "^## Don't do this" "$file"; then
    echo -e "${YELLOW}WARN${NC} $relpath: missing '## Don't do this' section (recommended)"
    warnings=$((warnings + 1))
  fi

  if [ "$file_errors" -eq 0 ]; then
    passed=$((passed + 1))
  fi
  errors=$((errors + file_errors))
done

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  error-messages-decoded lint results${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Checked:  $checked files"
echo -e "  Passed:   ${GREEN}$passed${NC}"
echo -e "  Errors:   ${RED}$errors${NC}"
echo -e "  Warnings: ${YELLOW}$warnings${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ "$errors" -gt 0 ]; then
  echo -e "\n${RED}Lint failed with $errors error(s).${NC}"
  exit 1
else
  echo -e "\n${GREEN}All files passed!${NC}"
  exit 0
fi
