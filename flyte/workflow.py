"""Flyte workflow for error-messages-decoded evaluation."""

from __future__ import annotations

import json
import os
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path

import requests
from flytekit import task, workflow, dynamic

from search import get_mcp_context

DATASET = Path(__file__).parent.parent / "v0.0.9" / "dataset" / "ground-truth.json"
RESPONSES_DIR = Path(__file__).parent.parent / "v0.0.9" / "results" / "responses"


# ---------- dataclasses ----------

@dataclass
class TestCase:
    id: str
    error: str
    context: str
    must_contain: list[str]
    must_not_suggest: list[str]
    source: str
    covered: bool


@dataclass
class CaseResult:
    case_id: str
    covered: bool
    haiku_correct: bool
    haiku_safe: bool
    qwen_correct: bool
    qwen_safe: bool
    mcp_correct: bool
    mcp_safe: bool
    mcp_matched: bool
    haiku_response: str = ""
    qwen_response: str = ""
    mcp_response: str = ""


# ---------- helpers (not tasks) ----------

def _build_prompt(error: str, context: str) -> str:
    return f"""I got this error: {error}

Context: {context}

What is the root cause and how do I fix it? Be specific."""


def _build_mcp_prompt(base_prompt: str, mcp_ctx: str) -> str:
    return f"""Here is a possibly related error from a knowledge base. Only use this if the error message closely matches the one below. If it does not match, ignore it completely and answer from your own knowledge.

---
{mcp_ctx}
---

{base_prompt}"""


def _any_branch(pattern: str, response: str) -> bool:
    """Match `pattern` against `response`, case-insensitive.

    `pattern` is an alternation built with "|" (e.g. "a|b|c"). If it is not a
    valid regex, fall back to a literal substring test PER ALTERNATIVE, not on
    the whole "a|b|c" string. The old fallback tested the joined string as one
    substring, which never matched after a re.error and produced silent false
    negatives in scoring.
    """
    try:
        return bool(re.search(pattern, response, re.IGNORECASE))
    except re.error:
        low = response.lower()
        return any(part.lower() in low for part in pattern.split("|") if part)


def _score(response: str, must_contain: str, must_not: str) -> tuple[bool, bool]:
    correct = False
    safe = True
    if must_contain:
        correct = _any_branch(must_contain, response)
    if must_not:
        safe = not _any_branch(must_not, response)
    return correct, safe


def _call_haiku(prompt: str) -> str:
    result = subprocess.run(
        ["claude", "-p", "--model", "haiku",
         "--mcp-config", '{"mcpServers":{}}', "--strict-mcp-config"],
        input=prompt, capture_output=True, text=True, timeout=90,
    )
    if result.returncode != 0:
        return f"FAILED: {result.stderr[:200]}"
    return result.stdout.strip()


def _call_qwen(prompt: str) -> str:
    import time
    ollama_url = os.environ.get("OLLAMA_URL", "http://localhost:11434")
    for attempt in range(5):
        try:
            resp = requests.post(
                f"{ollama_url}/api/generate",
                json={"model": "qwen2.5:1.5b", "prompt": prompt,
                      "stream": False, "options": {"temperature": 0}},
                timeout=180,
            )
            resp.raise_for_status()
            return resp.json().get("response", "FAILED")
        except (requests.exceptions.Timeout, requests.exceptions.ConnectionError):
            if attempt < 4:
                time.sleep(10 * (attempt + 1))
    return "FAILED: timeout after 5 retries"


# ---------- Flyte tasks ----------

@task(cache=True, cache_version="4-save-responses", retries=1, timeout=300)
def eval_single_case(
    case_id: str,
    error: str,
    context: str,
    must_contain_list: list[str],
    must_not_list: list[str],
    covered: bool,
) -> CaseResult:
    """Evaluate a single case: MCP lookup + 3 model calls + scoring."""
    must_contain = "|".join(must_contain_list)
    must_not = "|".join(must_not_list)
    base_prompt = _build_prompt(error, context)

    # MCP context
    mcp_ctx = get_mcp_context(error)
    mcp_matched = mcp_ctx is not None and mcp_ctx.startswith("Found")
    mcp_prompt = _build_mcp_prompt(base_prompt, mcp_ctx) if mcp_matched else base_prompt

    # Call all 3 models
    h_resp = _call_haiku(base_prompt)
    q_resp = _call_qwen(base_prompt)
    m_resp = _call_qwen(mcp_prompt)

    # Score
    hc, hs = _score(h_resp, must_contain, must_not)
    qc, qs = _score(q_resp, must_contain, must_not)
    mc, ms = _score(m_resp, must_contain, must_not)

    # Save responses to files
    RESPONSES_DIR.mkdir(parents=True, exist_ok=True)
    (RESPONSES_DIR / f"{case_id}-haiku.md").write_text(h_resp)
    (RESPONSES_DIR / f"{case_id}-qwen.md").write_text(q_resp)
    (RESPONSES_DIR / f"{case_id}-qwen-mcp.md").write_text(m_resp)

    # Log
    cov = "COV" if covered else "UNC"
    h_lbl = "OK" if hc else "X"
    q_lbl = "OK" if qc else "X"
    m_lbl = "OK" if mc else "X"
    if not hs: h_lbl += "!"
    if not qs: q_lbl += "!"
    if not ms: m_lbl += "!"
    mcp_lbl = "yes" if mcp_matched else "no"
    print(f"[{cov}] {case_id:50s} mcp={mcp_lbl} H={h_lbl} q={q_lbl} q+M={m_lbl}")

    return CaseResult(
        case_id=case_id, covered=covered,
        haiku_correct=hc, haiku_safe=hs,
        qwen_correct=qc, qwen_safe=qs,
        mcp_correct=mc, mcp_safe=ms,
        mcp_matched=mcp_matched,
        haiku_response=h_resp,
        qwen_response=q_resp,
        mcp_response=m_resp,
    )


@task
def load_cases(dataset_path: str) -> list[TestCase]:
    with open(dataset_path) as f:
        raw = json.load(f)
    return [
        TestCase(
            id=c["id"], error=c["error"], context=c["context"],
            must_contain=c.get("must_contain", []),
            must_not_suggest=c.get("must_not_suggest", []),
            source=c["source"], covered=c["covered"],
        )
        for c in raw
    ]


@task
def aggregate(results: list[CaseResult]) -> str:
    total = len(results)
    h_ok = sum(1 for r in results if r.haiku_correct)
    q_ok = sum(1 for r in results if r.qwen_correct)
    m_ok = sum(1 for r in results if r.mcp_correct)
    h_safe = sum(1 for r in results if r.haiku_safe)
    q_safe = sum(1 for r in results if r.qwen_safe)
    m_safe = sum(1 for r in results if r.mcp_safe)

    cov = [r for r in results if r.covered]
    unc = [r for r in results if not r.covered]

    helped = sum(1 for r in results if not r.qwen_correct and r.mcp_correct)
    hurt = sum(1 for r in results if r.qwen_correct and not r.mcp_correct)

    hit = [r for r in results if r.mcp_matched]
    miss = [r for r in results if not r.mcp_matched]

    lines = [
        "=" * 60,
        f"  RESULTS ({total} cases)",
        "=" * 60,
        "",
        f"              Haiku    qwen     qwen+MCP",
        f"  Correct:    {h_ok}/{total}     {q_ok}/{total}      {m_ok}/{total}",
        f"  Safe:       {h_safe}/{total}     {q_safe}/{total}      {m_safe}/{total}",
        "",
        f"  Covered ({len(cov)}):",
        f"    Haiku {sum(1 for r in cov if r.haiku_correct)}/{len(cov)}  qwen {sum(1 for r in cov if r.qwen_correct)}/{len(cov)}  qwen+MCP {sum(1 for r in cov if r.mcp_correct)}/{len(cov)}",
        f"  Not covered ({len(unc)}):",
        f"    Haiku {sum(1 for r in unc if r.haiku_correct)}/{len(unc)}  qwen {sum(1 for r in unc if r.qwen_correct)}/{len(unc)}  qwen+MCP {sum(1 for r in unc if r.mcp_correct)}/{len(unc)}",
        "",
        f"  MCP: helped {helped}, hurt {hurt}, delta {helped - hurt:+d}",
        f"  MCP hit: {sum(1 for r in hit if r.mcp_correct)}/{len(hit)}  miss: {sum(1 for r in miss if r.mcp_correct)}/{len(miss)}",
        "",
        "  Per-case:",
    ]

    for r in results:
        cov_lbl = "COV" if r.covered else "UNC"
        h = "OK" if r.haiku_correct else "X"
        q = "OK" if r.qwen_correct else "X"
        m = "OK" if r.mcp_correct else "X"
        hs = "" if r.haiku_safe else "!"
        qs = "" if r.qwen_safe else "!"
        ms = "" if r.mcp_safe else "!"
        mcp = "Y" if r.mcp_matched else "N"
        lines.append(f"    [{cov_lbl}] {r.case_id:50s} mcp={mcp} H={h}{hs} q={q}{qs} q+M={m}{ms}")

    report = "\n".join(lines)
    print(report)
    return report


# ---------- workflow ----------

@dynamic
def run_all(cases: list[TestCase]) -> str:
    results: list[CaseResult] = []
    for case in cases:
        r = eval_single_case(
            case_id=case.id, error=case.error, context=case.context,
            must_contain_list=case.must_contain,
            must_not_list=case.must_not_suggest,
            covered=case.covered,
        )
        results.append(r)
    return aggregate(results=results)


@workflow
def eval_workflow(dataset_path: str = str(DATASET)) -> str:
    cases = load_cases(dataset_path=dataset_path)
    return run_all(cases=cases)


if __name__ == "__main__":
    print(eval_workflow())
