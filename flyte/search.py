"""Semantic search for error knowledge base using embeddings."""

from __future__ import annotations

import json
import pickle
from dataclasses import dataclass
from pathlib import Path

import numpy as np
from sentence_transformers import SentenceTransformer

ERROR_INDEX = Path(__file__).parent.parent / "mcp-server" / "dist" / "error-index.json"
EMBEDDINGS_CACHE = Path(__file__).parent / ".embeddings-cache.pkl"

# Minimum cosine similarity to consider a match
SIMILARITY_THRESHOLD = 0.55

# Stacks NOT in our base
UNCOVERED_STACKS = frozenset([
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
])


@dataclass
class SearchResult:
    title: str
    stack: str
    error_message: str
    what_happened: str
    why_it_happens: str
    how_to_fix: str
    still_not_working: str
    similarity: float


def _is_uncovered(query: str) -> bool:
    q = query.lower()
    return any(kw in q for kw in UNCOVERED_STACKS)


def _load_index() -> list[dict]:
    with open(ERROR_INDEX) as f:
        return json.load(f)


class SemanticSearch:
    def __init__(self):
        self.model: SentenceTransformer | None = None
        self.index: list[dict] = []
        self.embeddings: np.ndarray | None = None

    def _ensure_loaded(self):
        if self.model is not None:
            return

        self.model = SentenceTransformer("all-MiniLM-L6-v2")
        self.index = _load_index()

        # Try loading cached embeddings
        if EMBEDDINGS_CACHE.exists():
            with open(EMBEDDINGS_CACHE, "rb") as f:
                cached = pickle.load(f)
            if cached.get("count") == len(self.index):
                self.embeddings = cached["embeddings"]
                return

        # Build embeddings: combine title + error message for each entry
        texts = [
            f"{e['title']}. {e['errorMessage'][:200]}"
            for e in self.index
        ]
        self.embeddings = self.model.encode(texts, normalize_embeddings=True)

        # Cache
        with open(EMBEDDINGS_CACHE, "wb") as f:
            pickle.dump({"count": len(self.index), "embeddings": self.embeddings}, f)

    def search(self, query: str, limit: int = 1) -> list[SearchResult]:
        # Block uncovered stacks
        if _is_uncovered(query):
            return []

        self._ensure_loaded()
        assert self.model is not None
        assert self.embeddings is not None

        # Encode query
        q_emb = self.model.encode([query], normalize_embeddings=True)

        # Cosine similarity (embeddings are already normalized)
        sims = (self.embeddings @ q_emb.T).flatten()

        # Get top matches above threshold
        top_idx = np.argsort(sims)[::-1][:limit * 2]  # get extra candidates
        results = []
        for idx in top_idx:
            sim = float(sims[idx])
            if sim < SIMILARITY_THRESHOLD:
                break
            entry = self.index[idx]
            results.append(SearchResult(
                title=entry["title"],
                stack=entry["stack"],
                error_message=entry["errorMessage"],
                what_happened=entry.get("whatHappened", ""),
                why_it_happens=entry.get("whyItHappens", ""),
                how_to_fix=entry.get("howToFix", ""),
                still_not_working=entry.get("stillNotWorking", ""),
                similarity=sim,
            ))
            if len(results) >= limit:
                break

        return results


# Singleton
_searcher = SemanticSearch()


def format_result(r: SearchResult) -> str:
    parts = [f"# {r.title}\n\n**Stack:** {r.stack}\n\n> {r.error_message}"]
    if r.what_happened:
        parts.append(f"\n\n## What happened\n{r.what_happened}")
    if r.why_it_happens:
        parts.append(f"\n\n## Why it happens\n{r.why_it_happens}")
    if r.how_to_fix:
        parts.append(f"\n\n## How to fix it\n{r.how_to_fix}")
    if r.still_not_working:
        parts.append(f"\n\n## Still not working?\n{r.still_not_working}")
    return "".join(parts)


def get_mcp_context(error_message: str) -> str | None:
    """Returns formatted MCP context or None if no match."""
    results = _searcher.search(error_message, limit=1)
    if not results:
        return None
    r = results[0]
    return f"Found 1 matching error (similarity: {r.similarity:.2f}):\n\n{format_result(r)}"
