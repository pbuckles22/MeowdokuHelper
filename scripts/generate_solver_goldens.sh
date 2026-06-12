#!/usr/bin/env bash
# Regenerate Dart solver golden files from Rust fixture gates (QA SSOT).
# See TEST_PLAN.md → QA/Coder separation; US-8.4 golden codegen.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/meowdoku_helper/rust"

cargo run --quiet --bin gen_solver_goldens

if [[ "${1:-}" == "--check" ]]; then
  cd "$ROOT"
  if ! git diff --quiet -- meowdoku_helper/lib/image/t2_t3_solver_goldens.dart \
    meowdoku_helper/lib/image/t4_solver_goldens.dart \
    meowdoku_helper/lib/image/t6_solver_goldens.dart; then
    echo "FAIL: generated solver goldens differ from committed files." >&2
    echo "Run ./scripts/generate_solver_goldens.sh and commit the result." >&2
    exit 1
  fi
  echo "PASS: solver goldens in sync with Rust fixtures"
fi
