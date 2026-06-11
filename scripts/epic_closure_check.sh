#!/usr/bin/env bash
# Epic closure mechanical checks — run after an epic ships to main.
# See .cursor/skills/epic-closure-gate/SKILL.md and RELEASE.md § SDLC cadence.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FAIL=0
warn() { echo "WARN: $*"; }
fail() { echo "FAIL: $*"; FAIL=1; }
pass() { echo "PASS: $*"; }

echo "=== Epic closure check ($(date -u +%Y-%m-%dT%H:%MZ)) ==="
echo "Repo: $ROOT"
echo

# 1. On main, clean working tree (optional strict)
BRANCH="$(git branch --show-current)"
if [[ "$BRANCH" != "main" ]]; then
  warn "Not on main (on '$BRANCH') — closure should run on main after merge"
else
  pass "On main"
fi

if [[ -n "$(git status --porcelain)" ]]; then
  warn "Working tree not clean — commit doc sync before declaring epic closed"
else
  pass "Working tree clean"
fi

# 2. Merged local branches (excluding main)
MERGED_LOCAL="$(git branch --merged main 2>/dev/null | grep -v '^\*' | grep -v '^  main$' | sed 's/^  //' || true)"
if [[ -n "$MERGED_LOCAL" ]]; then
  fail "Merged local branches still exist (delete with git branch -d):"
  echo "$MERGED_LOCAL" | sed 's/^/  /'
else
  pass "No merged local feature branches"
fi

# 3. Fetch and report merged remotes (excluding main/HEAD)
git fetch origin --quiet 2>/dev/null || warn "Could not fetch origin"
MERGED_REMOTE="$(git branch -r --merged main 2>/dev/null | grep -v 'origin/main' | grep -v 'origin/HEAD' | sed 's/^  //' || true)"
if [[ -n "$MERGED_REMOTE" ]]; then
  warn "Merged remote branches (consider git push origin --delete):"
  echo "$MERGED_REMOTE" | sed 's/^/  /'
else
  pass "No stale merged remote branches"
fi

# 4. Doc SHA drift — AGENT_HANDOFF should mention current HEAD short SHA
HEAD_SHA="$(git rev-parse --short HEAD)"
if grep -q "Active branch.*\`main\` @" AGENT_HANDOFF.md 2>/dev/null; then
  DOC_SHA="$(grep -oE 'main\` @ `[a-f0-9]+`' AGENT_HANDOFF.md | head -1 | grep -oE '[a-f0-9]{7,}' || true)"
  if [[ -n "$DOC_SHA" && "$DOC_SHA" != "$HEAD_SHA" ]]; then
    if git merge-base --is-ancestor "$DOC_SHA" HEAD 2>/dev/null; then
      pass "AGENT_HANDOFF.md SHA ($DOC_SHA) is ancestor of HEAD ($HEAD_SHA)"
    else
      fail "AGENT_HANDOFF.md SHA ($DOC_SHA) != HEAD ($HEAD_SHA) — sync tracked docs"
    fi
  else
    pass "AGENT_HANDOFF.md references current main SHA (or pattern not found)"
  fi
else
  warn "AGENT_HANDOFF.md missing 'Active branch: main @' pattern — sync Current state"
fi

# 5. PROJECT_STATUS last updated mentions recent year (weak staleness check)
if grep -q "Last updated:" doc/PROJECT_STATUS.md 2>/dev/null; then
  pass "PROJECT_STATUS.md has Last updated line"
else
  warn "PROJECT_STATUS.md missing Last updated"
fi

# 6. Merge-ready gate (fast — Rust + Flutter tests; analyze)
echo
echo "=== Merge-ready gate ==="
if (cd meowdoku_helper && flutter analyze >/dev/null 2>&1); then
  pass "flutter analyze"
else
  fail "flutter analyze"
fi

if (cd meowdoku_helper/rust && cargo test --lib --quiet >/dev/null 2>&1); then
  pass "cargo test --lib"
else
  fail "cargo test --lib"
fi

# Flutter test can be slow; run but allow skip-heavy FFI host
if (cd meowdoku_helper && flutter test >/dev/null 2>&1); then
  pass "flutter test"
else
  fail "flutter test"
fi

echo
if [[ "$FAIL" -eq 0 ]]; then
  echo "=== EPIC CLOSURE CHECK: PASS ==="
  exit 0
else
  echo "=== EPIC CLOSURE CHECK: FAIL ==="
  exit 1
fi
