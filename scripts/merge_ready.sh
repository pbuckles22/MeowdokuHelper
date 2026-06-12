#!/usr/bin/env bash
# Merge-ready gate — Tier 1a (Rust) + Tier 1b (Flutter).
# Canonical command for local dev, epic_closure_check.sh, and GitHub Actions.
# See TEST_PLAN.md and AGENT_HANDOFF.md.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/meowdoku_helper"

echo "=== Merge-ready gate ==="

flutter pub get
flutter analyze
echo "PASS: flutter analyze"

(cd rust && cargo test --lib)
echo "PASS: cargo test --lib"

flutter test
echo "PASS: flutter test"

echo "=== Merge-ready: PASS ==="
