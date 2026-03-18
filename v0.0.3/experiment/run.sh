#!/usr/bin/env bash
# Five-Way Eval
#
# A = qwen2.5:1.5b alone
# B = qwen2.5:1.5b + MCP
# C = qwen2.5:7b alone
# D = qwen2.5:7b + MCP
# E = Haiku alone

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_SERVER="$SCRIPT_DIR/../mcp-server/dist/index.js"
RESULTS_DIR="$SCRIPT_DIR/results"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
RESULTS_FILE="$RESULTS_DIR/five-way-$TIMESTAMP.json"
CASES_FILE="$SCRIPT_DIR/nightmare-phase2.json"

mkdir -p "$RESULTS_DIR/responses-5way"

ask_ollama() {
  local model="$1"
  local prompt="$2"
  curl -s http://localhost:11434/api/generate \
    -d "$(jq -n --arg model "$model" --arg prompt "$prompt" '{model:$model,prompt:$prompt,stream:false}')" \
    | jq -r '.response // "FAILED"' 2>/dev/null || echo "FAILED"
}

get_mcp_context() {
  local error_msg="$1"
  node -e "
const { spawn } = require('child_process');
const child = spawn('node', ['$MCP_SERVER'], { stdio: ['pipe', 'pipe', 'pipe'] });
let output = '';
child.stdout.on('data', d => { output += d.toString(); });
function send(msg) { child.stdin.write(JSON.stringify(msg) + '\n'); }
send({jsonrpc:'2.0',id:1,method:'initialize',params:{protocolVersion:'2024-11-05',capabilities:{},clientInfo:{name:'eval',version:'1.0'}}});
setTimeout(() => {
  send({jsonrpc:'2.0',method:'notifications/initialized'});
  setTimeout(() => {
    send({jsonrpc:'2.0',id:2,method:'tools/call',params:{name:'decode_error',arguments:{error_message:$(echo "$error_msg" | jq -Rs .),limit:1}}});
    setTimeout(() => {
      const lines = output.trim().split('\n');
      for (const line of lines) {
        try {
          const obj = JSON.parse(line);
          if (obj.id === 2 && obj.result) { console.log(obj.result.content[0].text); }
        } catch(e) {}
      }
      child.kill();
    }, 1500);
  }, 300);
}, 300);
" 2>/dev/null || echo "No MCP context found"
}

TOTAL=$(jq length "$CASES_FILE")

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Five-Way Eval ($TOTAL nightmare cases)"
echo "  A = qwen2.5:1.5b    B = 1.5b+MCP    C = qwen2.5:7b    D = 7b+MCP    E = Haiku"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

RESULTS_JSON="[]"
A_OK=0; A_SAFE=0; B_OK=0; B_SAFE=0; C_OK=0; C_SAFE=0; D_OK=0; D_SAFE=0; E_OK=0; E_SAFE=0

for i in $(seq 0 $((TOTAL - 1))); do
  ID=$(jq -r ".[$i].id" "$CASES_FILE")
  ERROR=$(jq -r ".[$i].error" "$CASES_FILE")
  CONTEXT=$(jq -r ".[$i].context" "$CASES_FILE")
  MUST_CONTAIN=$(jq -r ".[$i].must_contain[]" "$CASES_FILE" 2>/dev/null | tr '\n' '|' | sed 's/|$//')
  MUST_NOT=$(jq -r ".[$i].must_not_suggest[]" "$CASES_FILE" 2>/dev/null | tr '\n' '|' | sed 's/|$//')

  PROMPT="I got this error: $ERROR

Context: $CONTEXT

What is the root cause and how do I fix it? Be specific with commands."

  MCP_PROMPT_PREFIX="Here is expert knowledge about this error from a curated error database:

---
MCP_CONTEXT_HERE
---

Using the knowledge above, answer this question:

"

  echo "[$((i + 1))/$TOTAL] $ID"

  # Get MCP context once (reused for B and D)
  echo "  Fetching MCP context..."
  MCP_CTX=$(get_mcp_context "$ERROR")
  PROMPT_WITH_MCP="${MCP_PROMPT_PREFIX/MCP_CONTEXT_HERE/$MCP_CTX}$PROMPT"

  # A: 1.5b alone
  echo "  A) 1.5b..."
  RA=$(ask_ollama "qwen2.5:1.5b" "$PROMPT")
  echo "$RA" > "$RESULTS_DIR/responses-5way/$ID-A-1.5b.md"

  # B: 1.5b + MCP
  echo "  B) 1.5b+MCP..."
  RB=$(ask_ollama "qwen2.5:1.5b" "$PROMPT_WITH_MCP")
  echo "$RB" > "$RESULTS_DIR/responses-5way/$ID-B-1.5b-mcp.md"

  # C: 7b alone
  echo "  C) 7b..."
  RC=$(ask_ollama "qwen2.5:7b" "$PROMPT")
  echo "$RC" > "$RESULTS_DIR/responses-5way/$ID-C-7b.md"

  # D: 7b + MCP
  echo "  D) 7b+MCP..."
  RD=$(ask_ollama "qwen2.5:7b" "$PROMPT_WITH_MCP")
  echo "$RD" > "$RESULTS_DIR/responses-5way/$ID-D-7b-mcp.md"

  # E: Haiku alone
  echo "  E) Haiku..."
  RE=$(echo "$PROMPT" | claude -p --model haiku --mcp-config '{"mcpServers":{}}' --strict-mcp-config 2>/dev/null || echo "FAILED")
  echo "$RE" > "$RESULTS_DIR/responses-5way/$ID-E-haiku.md"

  score() {
    local resp="$1" c=0 s=1
    [ -n "$MUST_CONTAIN" ] && echo "$resp" | grep -qiE "$MUST_CONTAIN" 2>/dev/null && c=1
    [ -n "$MUST_NOT" ] && echo "$resp" | grep -qiE "$MUST_NOT" 2>/dev/null && s=0
    echo "$c $s"
  }

  read AC AS <<< $(score "$RA")
  read BC BS <<< $(score "$RB")
  read CC CS <<< $(score "$RC")
  read DC DS <<< $(score "$RD")
  read EC ES <<< $(score "$RE")

  A_OK=$((A_OK+AC)); A_SAFE=$((A_SAFE+AS))
  B_OK=$((B_OK+BC)); B_SAFE=$((B_SAFE+BS))
  C_OK=$((C_OK+CC)); C_SAFE=$((C_SAFE+CS))
  D_OK=$((D_OK+DC)); D_SAFE=$((D_SAFE+DS))
  E_OK=$((E_OK+EC)); E_SAFE=$((E_SAFE+ES))

  lbl() { local c=$1 s=$2; [ "$c" -eq 1 ] && printf "OK" || printf "X "; [ "$s" -eq 0 ] && printf "!"; printf " "; }

  echo "     A=$(lbl $AC $AS) B=$(lbl $BC $BS) C=$(lbl $CC $CS) D=$(lbl $DC $DS) E=$(lbl $EC $ES)"

  CASE_RESULT=$(jq -n --arg id "$ID" \
    --argjson ac "$AC" --argjson as "$AS" \
    --argjson bc "$BC" --argjson bs "$BS" \
    --argjson cc "$CC" --argjson cs "$CS" \
    --argjson dc "$DC" --argjson ds "$DS" \
    --argjson ec "$EC" --argjson es "$ES" \
    '{id:$id, "1.5b":{ok:($ac==1),safe:($as==1)}, "1.5b_mcp":{ok:($bc==1),safe:($bs==1)}, "7b":{ok:($cc==1),safe:($cs==1)}, "7b_mcp":{ok:($dc==1),safe:($ds==1)}, haiku:{ok:($ec==1),safe:($es==1)}}')
  RESULTS_JSON=$(echo "$RESULTS_JSON" | jq --argjson c "$CASE_RESULT" '. + [$c]')
  echo ""
done

echo "$RESULTS_JSON" | jq . > "$RESULTS_FILE"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  FIVE-WAY EVAL RESULTS ($TOTAL nightmare cases)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "                   1.5b    1.5b+MCP    7b    7b+MCP    Haiku"
echo "  ──────────────────────────────────────────────────────────"
echo "  Correct fix:     $A_OK/$TOTAL     $B_OK/$TOTAL         $C_OK/$TOTAL     $D_OK/$TOTAL       $E_OK/$TOTAL"
echo "  Safe:            $A_SAFE/$TOTAL     $B_SAFE/$TOTAL         $C_SAFE/$TOTAL     $D_SAFE/$TOTAL       $E_SAFE/$TOTAL"
echo "  ──────────────────────────────────────────────────────────"
echo "  Cost:            free    free        free   free       \$\$"
echo "  ──────────────────────────────────────────────────────────"
echo ""
echo "  Per-case:"
printf "  %-35s  1.5b  +MCP  7b    +MCP  Haiku\n" "Case"
echo "$RESULTS_JSON" | jq -r '.[] | "  \(.id | . + " " * (35 - length))  \(if .["1.5b"].ok then "OK" else "X " end)\(if .["1.5b"].safe then " " else "!" end)   \(if .["1.5b_mcp"].ok then "OK" else "X " end)\(if .["1.5b_mcp"].safe then " " else "!" end)   \(if .["7b"].ok then "OK" else "X " end)\(if .["7b"].safe then " " else "!" end)   \(if .["7b_mcp"].ok then "OK" else "X " end)\(if .["7b_mcp"].safe then " " else "!" end)   \(if .haiku.ok then "OK" else "X " end)\(if .haiku.safe then " " else "!" end)"'
echo ""
echo "  OK=correct  X=wrong  !=suggested anti-pattern"
echo ""
echo "  Responses: $RESULTS_DIR/responses-5way/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
