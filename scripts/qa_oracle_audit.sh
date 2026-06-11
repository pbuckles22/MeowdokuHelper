#!/usr/bin/env bash
# QA oracle backward audit — git coupling + manifest provenance.
# See doc/QA_ORACLE_AUDIT.md and doc/qa_oracle_manifest.yaml

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

STRICT=0
[[ "${1:-}" == "--strict" ]] && STRICT=1

MANIFEST="$ROOT/doc/qa_oracle_manifest.yaml"
FAIL=0

warn() { echo "WARN: $*"; }
fail() { echo "FAIL: $*"; FAIL=1; }
pass() { echo "PASS: $*"; }
info() { echo "INFO: $*"; }

echo "=== QA oracle audit ($(date -u +%Y-%m-%dT%H:%MZ)) ==="
echo "Repo: $ROOT"
echo

if [[ ! -f "$MANIFEST" ]]; then
  fail "Missing manifest: doc/qa_oracle_manifest.yaml"
  exit 1
fi

# --- 1. Coupled commits (QA + Coder paths same commit) ---
info "Git coupling scan (main branch)..."

COUPLED="$(python3 <<'PY'
import re, subprocess
log = subprocess.check_output(
    ["git", "log", "--pretty=format:%h %s", "--name-only", "main"], text=True
)
commits = []
cur = None
title = ""
files = []
for line in log.splitlines():
    if re.match(r"^[0-9a-f]{7,} ", line):
        if cur:
            commits.append((cur, title, files))
        parts = line.split(" ", 1)
        cur, title = parts[0], parts[1] if len(parts) > 1 else ""
        files = []
    elif line.strip():
        files.append(line.strip())
if cur:
    commits.append((cur, title, files))

qa = re.compile(
    r"(meowdoku_helper/test/|integration_test/|_goldens\.dart|_fixtures\.rs|"
    r"grid_goldens\.dart|doc/plan/FIXTURES\.md|doc/qa_oracle_manifest\.yaml)"
)
coder = re.compile(
    r"(rust/src/solver/tier|rust/src/solver/mod\.rs|rust/src/api/meowdoku|"
    r"lib/app/|lib/image/(?!.*goldens))"
)
coupled = []
for sha, title, fs in commits:
    q = [f for f in fs if qa.search(f)]
    c = [f for f in fs if coder.search(f)]
    if q and c:
        coupled.append((sha, title, q, c))
print(len(coupled))
for sha, title, q, c in coupled:
    print(f"COMMIT|{sha}|{title}")
    for f in q + c:
        print(f"FILE|{f}")
PY
)"

COUPLED_COUNT="$(echo "$COUPLED" | head -1)"
echo "Coupled QA+Coder commits on main: $COUPLED_COUNT"
if [[ "$COUPLED_COUNT" -gt 0 ]]; then
  warn "These commits touched tests/goldens AND solver/app in one changeset (suspicious):"
  echo "$COUPLED" | tail -n +2 | awk -F'|' '
    /^COMMIT\|/ { printf "\n  %s %s\n", $2, $3; next }
    /^FILE\|/ { print "    " $2 }
  '
else
  pass "No coupled commits detected"
fi
echo

# --- 2. Manifest pending / priority ---
info "Manifest provenance scan..."

MANIFEST_REPORT="$(python3 <<'PY'
import re, pathlib
text = pathlib.Path("doc/qa_oracle_manifest.yaml").read_text()
blocks = re.split(r"\n  - id:", text)
items = []
for b in blocks[1:]:
    def grab(key):
        m = re.search(rf"^\s*{key}:\s*(.+)$", b, re.M)
        return m.group(1).strip() if m else ""
    aid = grab("id") or re.match(r"\s*(\S+)", b)
    aid = re.match(r"\s*(\S+)", b).group(1) if re.match(r"\s*(\S+)", b) else "?"
    status = grab("audit_status")
    priority = grab("priority") or "P9"
    oracle = grab("oracle")
    items.append((priority, aid, status, oracle))

pending_p1 = [x for x in items if x[2] == "pending" and x[0] == "P1"]
pending_p2 = [x for x in items if x[2] == "pending" and x[0] == "P2"]
pending_all = [x for x in items if x[2] == "pending"]
unaudited = [x for x in items if x[3] == "unaudited"]

print(f"PENDING_COUNT|{len(pending_all)}")
print(f"P1_PENDING|{len(pending_p1)}")
print(f"P2_PENDING|{len(pending_p2)}")
print(f"UNAUDITED_ORACLE|{len(unaudited)}")
for p, aid, st, orc in sorted(items):
    risk = "high" if (st == "pending" and p in ("P1", "P2")) or orc == "unaudited" else "medium" if st == "pending" else "low"
    print(f"ARTIFACT|{aid}|{p}|{st}|{orc}|{risk}")
PY
)"

echo "$MANIFEST_REPORT" | while IFS='|' read -r kind a b c d e; do
  case "$kind" in
    PENDING_COUNT) echo "Manifest artifacts pending audit: $a" ;;
    P1_PENDING)
      if [[ "$a" -gt 0 ]]; then
        warn "P1 pending: $a (independent oracle required — see doc/QA_ORACLE_AUDIT.md)"
        [[ "$STRICT" -eq 1 ]] && fail "P1 audit incomplete"
      else
        pass "P1 artifacts verified or accepted"
      fi
      ;;
    P2_PENDING)
      if [[ "$a" -gt 0 ]]; then
        warn "P2 pending: $a"
        [[ "$STRICT" -eq 1 ]] && fail "P2 audit incomplete"
      fi
      ;;
    UNAUDITED_ORACLE) echo "Artifacts with oracle=unaudited: $a" ;;
    ARTIFACT) echo "  [$e] $a — $c (oracle: $d, $b)" ;;
  esac
done
echo

# --- 3. QA-owned paths vs manifest coverage (sample) ---
info "Manifest path coverage (spot check)..."

python3 <<'PY'
import re, pathlib, subprocess
manifest = pathlib.Path("doc/qa_oracle_manifest.yaml").read_text()
listed = set(re.findall(r"meowdoku_helper/[^\s\]]+", manifest))
# Key QA-owned files that must be in manifest
required = [
    "meowdoku_helper/test/t6_fixture_gate_test.dart",
    "meowdoku_helper/rust/src/solver/t6_fixtures.rs",
    "meowdoku_helper/lib/image/t6_solver_goldens.dart",
    "meowdoku_helper/lib/image/grid_goldens.dart",
    "meowdoku_helper/rust/src/solver/tier4_phantom.rs",
]
missing = [p for p in required if p not in manifest]
if missing:
    print("FAIL: manifest missing paths:")
    for m in missing:
        print(" ", m)
else:
    print("PASS: required QA paths listed in manifest")
PY

echo
info "Next steps:"
echo "  1. QA session per doc/QA_ORACLE_AUDIT.md (one artifact id at a time)"
echo "  2. Record derivations in doc/qa_derivations/"
echo "  3. Update doc/qa_oracle_manifest.yaml audit_status"
echo "  4. Re-run: ./scripts/qa_oracle_audit.sh --strict"
echo

if [[ "$FAIL" -ne 0 ]]; then
  echo "=== QA oracle audit: FAIL ==="
  exit 1
fi
echo "=== QA oracle audit: PASS (report mode; use --strict to gate on P1/P2) ==="
