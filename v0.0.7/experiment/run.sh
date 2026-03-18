#!/usr/bin/env bash
# Phase 3 V3: Clean eval with SO-sourced test cases
# 3 conditions: Haiku, qwen1.5b, qwen1.5b+MCP
# 20 cases: 10 covered by MCP base, 10 NOT covered

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
MCP_SERVER="$VERSION_DIR/../../mcp-server/dist/index.js"
CASES_FILE="$VERSION_DIR/dataset/ground-truth.json"

mkdir -p "$VERSION_DIR/results/responses"

ask_ollama() {
  curl -s http://localhost:11434/api/generate \
    -d "$(jq -n --arg model "$1" --arg prompt "$2" '{model:$model,prompt:$prompt,stream:false,options:{temperature:0}}')" \
    | jq -r '.response // "FAILED"' 2>/dev/null || echo "FAILED"
}

get_mcp_context() {
  node -e "
const{spawn}=require('child_process');
const c=spawn('node',['$MCP_SERVER'],{stdio:['pipe','pipe','pipe']});
let o='';c.stdout.on('data',d=>{o+=d.toString()});
function s(m){c.stdin.write(JSON.stringify(m)+'\n')}
s({jsonrpc:'2.0',id:1,method:'initialize',params:{protocolVersion:'2024-11-05',capabilities:{},clientInfo:{name:'e',version:'1'}}});
setTimeout(()=>{s({jsonrpc:'2.0',method:'notifications/initialized'});
setTimeout(()=>{s({jsonrpc:'2.0',id:2,method:'tools/call',params:{name:'decode_error',arguments:{error_message:$(echo "$1"|jq -Rs .),limit:1}}});
setTimeout(()=>{const l=o.trim().split('\n');for(const x of l){try{const j=JSON.parse(x);if(j.id===2&&j.result)console.log(j.result.content[0].text)}catch(e){}}c.kill()},1500)},300)},300);
" 2>/dev/null || echo ""
}

TOTAL=$(jq length "$CASES_FILE")

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Phase 3: Stack Overflow Eval ($TOTAL cases)"
echo "  10 covered by MCP base + 10 NOT covered"
echo "  Haiku vs qwen1.5b vs qwen1.5b+MCP"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Counters
H_OK=0; H_SAFE=0; Q_OK=0; Q_SAFE=0; M_OK=0; M_SAFE=0
H_COV_OK=0; H_UNC_OK=0; Q_COV_OK=0; Q_UNC_OK=0; M_COV_OK=0; M_UNC_OK=0
COV_TOTAL=0; UNC_TOTAL=0
MCP_HIT_OK=0; MCP_HIT_TOTAL=0; MCP_MISS_OK=0; MCP_MISS_TOTAL=0

for i in $(seq 0 $((TOTAL - 1))); do
  ID=$(jq -r ".[$i].id" "$CASES_FILE")
  ERROR=$(jq -r ".[$i].error" "$CASES_FILE")
  CONTEXT=$(jq -r ".[$i].context" "$CASES_FILE")
  COVERED=$(jq -r ".[$i].covered" "$CASES_FILE")
  MUST_CONTAIN=$(jq -r ".[$i].must_contain[]" "$CASES_FILE" 2>/dev/null | tr '\n' '|' | sed 's/|$//')
  MUST_NOT=$(jq -r ".[$i].must_not_suggest[]" "$CASES_FILE" 2>/dev/null | tr '\n' '|' | sed 's/|$//')
  SOURCE=$(jq -r ".[$i].source" "$CASES_FILE")

  if [ "$COVERED" = "true" ]; then
    COV_TOTAL=$((COV_TOTAL+1))
    COV_LABEL="COVERED"
  else
    UNC_TOTAL=$((UNC_TOTAL+1))
    COV_LABEL="NOT-COV"
  fi

  PROMPT="I got this error: $ERROR

Context: $CONTEXT

What is the root cause and how do I fix it? Be specific."

  echo "[$((i + 1))/$TOTAL] [$COV_LABEL] $ID"

  # Get MCP context
  MCP_CTX=$(get_mcp_context "$ERROR")
  MCP_HAS_MATCH="no"
  echo "$MCP_CTX" | grep -q "No matching errors" || MCP_HAS_MATCH="yes"
  echo "  MCP match: $MCP_HAS_MATCH"

  # Only inject MCP context if there's an actual match
  # When no match: use the exact same prompt as baseline (no noise)
  if [ "$MCP_HAS_MATCH" = "yes" ]; then
    PROMPT_MCP="Here is expert knowledge about this error:

---
$MCP_CTX
---

Using the knowledge above, answer:

$PROMPT"
  else
    PROMPT_MCP="$PROMPT"
  fi

  score() {
    local resp="$1" c=0 s=1
    [ -n "$MUST_CONTAIN" ] && echo "$resp" | grep -qiEP "$MUST_CONTAIN" 2>/dev/null && c=1
    [ "$c" -eq 0 ] && [ -n "$MUST_CONTAIN" ] && echo "$resp" | grep -qiE "$MUST_CONTAIN" 2>/dev/null && c=1
    [ -n "$MUST_NOT" ] && echo "$resp" | grep -qiE "$MUST_NOT" 2>/dev/null && s=0
    echo "$c $s"
  }

  # Haiku
  echo -n "  Haiku..."
  RH=$(echo "$PROMPT" | claude -p --model haiku --mcp-config '{"mcpServers":{}}' --strict-mcp-config 2>/dev/null || echo "FAILED")
  echo "$RH" > "$VERSION_DIR/results/responses/$ID-haiku.md"
  read HC HS <<< $(score "$RH")
  H_OK=$((H_OK+HC)); H_SAFE=$((H_SAFE+HS))
  [ "$COVERED" = "true" ] && H_COV_OK=$((H_COV_OK+HC)) || H_UNC_OK=$((H_UNC_OK+HC))

  # qwen 1.5b
  echo -n " qwen..."
  RQ=$(ask_ollama "qwen2.5:1.5b" "$PROMPT")
  echo "$RQ" > "$VERSION_DIR/results/responses/$ID-qwen.md"
  read QC QS <<< $(score "$RQ")
  Q_OK=$((Q_OK+QC)); Q_SAFE=$((Q_SAFE+QS))
  [ "$COVERED" = "true" ] && Q_COV_OK=$((Q_COV_OK+QC)) || Q_UNC_OK=$((Q_UNC_OK+QC))

  # qwen 1.5b + MCP
  echo -n " qwen+MCP..."
  RM=$(ask_ollama "qwen2.5:1.5b" "$PROMPT_MCP")
  echo "$RM" > "$VERSION_DIR/results/responses/$ID-qwen-mcp.md"
  read MC MS <<< $(score "$RM")
  M_OK=$((M_OK+MC)); M_SAFE=$((M_SAFE+MS))
  [ "$COVERED" = "true" ] && M_COV_OK=$((M_COV_OK+MC)) || M_UNC_OK=$((M_UNC_OK+MC))

  # Track MCP hit impact
  if [ "$MCP_HAS_MATCH" = "yes" ]; then
    MCP_HIT_TOTAL=$((MCP_HIT_TOTAL+1))
    MCP_HIT_OK=$((MCP_HIT_OK+MC))
  else
    MCP_MISS_TOTAL=$((MCP_MISS_TOTAL+1))
    MCP_MISS_OK=$((MCP_MISS_OK+MC))
  fi

  lbl() { [ "$1" -eq 1 ] && printf "OK" || printf "X "; [ "$2" -eq 0 ] && printf "!"; }
  echo ""
  echo "  Haiku=$(lbl $HC $HS)  qwen=$(lbl $QC $QS)  qwen+MCP=$(lbl $MC $MS)"
  echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  RESULTS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Overall ($TOTAL cases):"
echo "                Haiku    qwen1.5b   qwen+MCP"
echo "  ─────────────────────────────────────────"
echo "  Correct:      $H_OK/$TOTAL      $Q_OK/$TOTAL        $M_OK/$TOTAL"
echo "  Safe:         $H_SAFE/$TOTAL      $Q_SAFE/$TOTAL        $M_SAFE/$TOTAL"
echo ""
echo "  By coverage:"
echo "  Covered ($COV_TOTAL):    $H_COV_OK/$COV_TOTAL      $Q_COV_OK/$COV_TOTAL        $M_COV_OK/$COV_TOTAL"
echo "  Not covered ($UNC_TOTAL): $H_UNC_OK/$UNC_TOTAL      $Q_UNC_OK/$UNC_TOTAL        $M_UNC_OK/$UNC_TOTAL"
echo ""
echo "  MCP hit impact (qwen+MCP only):"
echo "  When MCP had match:    $MCP_HIT_OK/$MCP_HIT_TOTAL correct"
echo "  When MCP had NO match: $MCP_MISS_OK/$MCP_MISS_TOTAL correct"
echo ""
echo "  Responses: $VERSION_DIR/results/responses/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
