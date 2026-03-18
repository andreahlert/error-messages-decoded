#!/usr/bin/env bash
# Eval: measures whether error-messages-decoded MCP improves AI error diagnosis
#
# Runs each test case twice:
#   1. WITHOUT MCP (baseline) - Claude answers from its own knowledge
#   2. WITH MCP (treatment) - Claude can use decode_error tool
#
# Then uses a judge prompt to score each response against ground truth.
#
# Output: results/eval-{timestamp}.json with per-case scores and summary

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/results"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RESULTS_FILE="$RESULTS_DIR/eval-$TIMESTAMP.json"
TEST_CASES="$SCRIPT_DIR/test-cases.json"

mkdir -p "$RESULTS_DIR"

TOTAL=$(jq length "$TEST_CASES")
echo "Running eval with $TOTAL test cases..."
echo ""

# Temp files for collecting results
RESULTS_JSON="[]"

for i in $(seq 0 $((TOTAL - 1))); do
  ID=$(jq -r ".[$i].id" "$TEST_CASES")
  ERROR_MSG=$(jq -r ".[$i].error_message" "$TEST_CASES")
  CONTEXT=$(jq -r ".[$i].context" "$TEST_CASES")
  GROUND_TRUTH=$(jq -c ".[$i].ground_truth" "$TEST_CASES")

  PROMPT="I got this error:

$ERROR_MSG

Context: $CONTEXT

Tell me: (1) what the root cause is, (2) how to fix it with exact commands or code, (3) what common bad fixes to avoid. Be specific and concise."

  echo "[$((i + 1))/$TOTAL] $ID"

  # Run WITHOUT MCP (baseline)
  echo "  Running baseline (no MCP)..."
  BASELINE=$(echo "$PROMPT" | claude --print --model haiku --mcp-config '{"mcpServers":{}}'  --strict-mcp-config 2>/dev/null || echo "ERROR: baseline failed")

  # Run WITH MCP (treatment)
  echo "  Running with MCP..."
  TREATMENT=$(echo "$PROMPT" | claude --print --model haiku --allowedTools 'mcp__error-decoded__*' 2>/dev/null || echo "ERROR: treatment failed")

  # Judge both responses
  JUDGE_PROMPT="You are an expert evaluator. Score two AI responses about a programming error.

ERROR: $ERROR_MSG
CONTEXT: $CONTEXT

GROUND TRUTH:
- Root cause: $(echo "$GROUND_TRUTH" | jq -r '.root_cause')
- Correct fix: $(echo "$GROUND_TRUTH" | jq -r '.correct_fix')
- Anti-pattern to avoid: $(echo "$GROUND_TRUTH" | jq -r '.anti_pattern')
- Key terms that should appear: $(echo "$GROUND_TRUTH" | jq -r '.keywords | join(", ")')

RESPONSE A (baseline, no tools):
$BASELINE

RESPONSE B (with error knowledge base):
$TREATMENT

Score each response on these criteria (1-5 scale):
1. root_cause_accuracy: Did it identify the correct root cause?
2. fix_quality: Is the fix correct, specific, and actionable?
3. anti_pattern_awareness: Did it warn against common bad fixes?
4. keyword_coverage: How many key terms from ground truth appeared?

Respond ONLY with valid JSON, no other text:
{
  \"baseline\": { \"root_cause_accuracy\": N, \"fix_quality\": N, \"anti_pattern_awareness\": N, \"keyword_coverage\": N },
  \"treatment\": { \"root_cause_accuracy\": N, \"fix_quality\": N, \"anti_pattern_awareness\": N, \"keyword_coverage\": N }
}"

  echo "  Judging..."
  JUDGE_RESULT=$(echo "$JUDGE_PROMPT" | claude --print --model haiku 2>/dev/null || echo '{"baseline":{"root_cause_accuracy":0,"fix_quality":0,"anti_pattern_awareness":0,"keyword_coverage":0},"treatment":{"root_cause_accuracy":0,"fix_quality":0,"anti_pattern_awareness":0,"keyword_coverage":0}}')

  # Extract JSON from judge response using Python for robustness
  JUDGE_JSON=$(python3 << 'PYEOF'
import sys, json

text = """PLACEHOLDER"""
default = {"baseline":{"root_cause_accuracy":3,"fix_quality":3,"anti_pattern_awareness":3,"keyword_coverage":3},"treatment":{"root_cause_accuracy":3,"fix_quality":3,"anti_pattern_awareness":3,"keyword_coverage":3}}

# Try to find valid JSON by scanning for { and trying to parse from each one
best = None
for i, c in enumerate(text):
    if c == '{':
        for j in range(len(text), i, -1):
            if text[j-1] == '}':
                try:
                    obj = json.loads(text[i:j])
                    if isinstance(obj, dict) and 'baseline' in obj and 'treatment' in obj:
                        best = obj
                        break
                except:
                    continue
        if best:
            break

print(json.dumps(best if best else default))
PYEOF
)
  # Replace placeholder with actual content
  JUDGE_JSON=$(python3 -c "
import sys, json
text = sys.stdin.read()
default = {\"baseline\":{\"root_cause_accuracy\":3,\"fix_quality\":3,\"anti_pattern_awareness\":3,\"keyword_coverage\":3},\"treatment\":{\"root_cause_accuracy\":3,\"fix_quality\":3,\"anti_pattern_awareness\":3,\"keyword_coverage\":3}}
best = None
for i, c in enumerate(text):
    if c == '{':
        for j in range(len(text), i, -1):
            if text[j-1] == '}':
                try:
                    obj = json.loads(text[i:j])
                    if isinstance(obj, dict) and 'baseline' in obj and 'treatment' in obj:
                        best = obj
                        break
                except:
                    continue
        if best:
            break
print(json.dumps(best if best else default))
" <<< "$JUDGE_RESULT" 2>/dev/null || echo '{"baseline":{"root_cause_accuracy":3,"fix_quality":3,"anti_pattern_awareness":3,"keyword_coverage":3},"treatment":{"root_cause_accuracy":3,"fix_quality":3,"anti_pattern_awareness":3,"keyword_coverage":3}}')

  # Add to results
  CASE_RESULT=$(jq -n \
    --arg id "$ID" \
    --arg error "$ERROR_MSG" \
    --argjson scores "$JUDGE_JSON" \
    '{ id: $id, error: $error, scores: $scores }')

  RESULTS_JSON=$(echo "$RESULTS_JSON" | jq --argjson case "$CASE_RESULT" '. + [$case]')

  # Print quick score
  B_AVG=$(echo "$JUDGE_JSON" | jq '[.baseline.root_cause_accuracy, .baseline.fix_quality, .baseline.anti_pattern_awareness, .baseline.keyword_coverage] | add / 4')
  T_AVG=$(echo "$JUDGE_JSON" | jq '[.treatment.root_cause_accuracy, .treatment.fix_quality, .treatment.anti_pattern_awareness, .treatment.keyword_coverage] | add / 4')
  echo "  Baseline: $B_AVG/5  |  With MCP: $T_AVG/5"
  echo ""
done

# Calculate summary
SUMMARY=$(echo "$RESULTS_JSON" | jq '{
  total_cases: length,
  baseline: {
    avg_root_cause: ([.[].scores.baseline.root_cause_accuracy] | add / length),
    avg_fix_quality: ([.[].scores.baseline.fix_quality] | add / length),
    avg_anti_pattern: ([.[].scores.baseline.anti_pattern_awareness] | add / length),
    avg_keyword_coverage: ([.[].scores.baseline.keyword_coverage] | add / length),
    avg_total: ([.[].scores.baseline | [.root_cause_accuracy, .fix_quality, .anti_pattern_awareness, .keyword_coverage] | add / 4] | add / length)
  },
  treatment: {
    avg_root_cause: ([.[].scores.treatment.root_cause_accuracy] | add / length),
    avg_fix_quality: ([.[].scores.treatment.fix_quality] | add / length),
    avg_anti_pattern: ([.[].scores.treatment.anti_pattern_awareness] | add / length),
    avg_keyword_coverage: ([.[].scores.treatment.keyword_coverage] | add / length),
    avg_total: ([.[].scores.treatment | [.root_cause_accuracy, .fix_quality, .anti_pattern_awareness, .keyword_coverage] | add / 4] | add / length)
  }
}')

# Build final output
FINAL=$(jq -n \
  --arg timestamp "$TIMESTAMP" \
  --argjson cases "$RESULTS_JSON" \
  --argjson summary "$SUMMARY" \
  '{ timestamp: $timestamp, cases: $cases, summary: $summary }')

echo "$FINAL" | jq . > "$RESULTS_FILE"

# Print summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  EVAL RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Cases: $TOTAL"
echo ""
echo "                    Baseline    With MCP    Delta"
echo "  ─────────────────────────────────────────────"

B_TOTAL=$(echo "$SUMMARY" | jq '.baseline.avg_total')
T_TOTAL=$(echo "$SUMMARY" | jq '.treatment.avg_total')
DELTA=$(echo "$B_TOTAL $T_TOTAL" | awk '{printf "%.2f", ($2 - $1)}')
PCT=$(echo "$B_TOTAL $T_TOTAL" | awk '{if ($1 > 0) printf "%.1f", (($2 - $1) / $1 * 100); else print "N/A"}')

echo "  Root cause:       $(echo "$SUMMARY" | jq '.baseline.avg_root_cause')      $(echo "$SUMMARY" | jq '.treatment.avg_root_cause')"
echo "  Fix quality:      $(echo "$SUMMARY" | jq '.baseline.avg_fix_quality')      $(echo "$SUMMARY" | jq '.treatment.avg_fix_quality')"
echo "  Anti-patterns:    $(echo "$SUMMARY" | jq '.baseline.avg_anti_pattern')      $(echo "$SUMMARY" | jq '.treatment.avg_anti_pattern')"
echo "  Keyword coverage: $(echo "$SUMMARY" | jq '.baseline.avg_keyword_coverage')      $(echo "$SUMMARY" | jq '.treatment.avg_keyword_coverage')"
echo "  ─────────────────────────────────────────────"
echo "  OVERALL:          $B_TOTAL      $T_TOTAL      +$DELTA (+$PCT%)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Full results: $RESULTS_FILE"
