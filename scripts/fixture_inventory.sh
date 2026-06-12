#!/usr/bin/env bash
# Inventory board screenshot fixtures vs gate coverage (Phase 8 H3).
# See doc/plan/FIXTURES.md and doc/plan/EPICS_AND_STORIES.md US-8.3.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURES_DIR="$ROOT/assets/test_fixtures"
FIXTURES_MD="$ROOT/doc/plan/FIXTURES.md"

STRICT=0
if [[ "${1:-}" == "--strict" ]]; then
  STRICT=1
fi

gate_for_seq() {
  local seq="$1"
  if (( seq >= 1 && seq <= 8 )); then echo "parse"; return; fi
  if (( seq >= 9 && seq <= 17 )); then echo "t2/t3"; return; fi
  if (( seq >= 18 && seq <= 19 )); then echo "t4"; return; fi
  if (( seq >= 22 && seq <= 30 )); then echo "t6"; return; fi
  echo "—"
}

echo "=== Fixture inventory ($(date -u +%Y-%m-%dT%H:%MZ)) ==="
echo "Directory: $FIXTURES_DIR"
echo

inventory="$(mktemp)"
trap 'rm -f "$inventory"' EXIT

for f in "$FIXTURES_DIR"/*; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  if [[ ! "$base" =~ ^([0-9]{2})_ ]]; then
    echo "WARN: skip non-catalog name: $base" >&2
    continue
  fi
  seq=$((10#${BASH_REMATCH[1]}))
  echo "$seq $base" >> "$inventory"
done

sort -n "$inventory" -o "$inventory"
count="$(wc -l < "$inventory" | tr -d ' ')"

echo "On disk: $count fixtures"
echo
printf "%-4s %-32s %-8s %-10s\n" "Seq" "File" "Gate" "In FIXTURES.md"
printf "%-4s %-32s %-8s %-10s\n" "---" "----" "----" "--------------"

missing_md=0
missing_on_disk=0
prev_seq=0
while IFS=' ' read -r seq file; do
  if (( seq == prev_seq )); then
    echo "FAIL: duplicate seq $(printf '%02d' "$seq")"
    exit 1
  fi
  prev_seq=$seq
done < "$inventory"

for n in $(seq 1 42); do
  seq="$(printf '%02d' "$n")"
  file="$(awk -v s="$n" '$1 == s {print $2; exit}' "$inventory")"
  gate="$(gate_for_seq "$n")"
  if [[ -z "$file" ]]; then
    printf "%-4s %-32s %-8s %-10s\n" "$seq" "(missing)" "$gate" "—"
    missing_on_disk=$((missing_on_disk + 1))
    continue
  fi
  in_md="no"
  if grep -qF "$file" "$FIXTURES_MD" 2>/dev/null; then
    in_md="yes"
  else
    missing_md=$((missing_md + 1))
  fi
  printf "%-4s %-32s %-8s %-10s\n" "$seq" "$file" "$gate" "$in_md"
done

echo
echo "Gate summary:"
echo "  parse (01–08): 8 expected"
echo "  t2/t3 (09–17): 9 expected"
echo "  t4 (18–19): 2 expected"
echo "  t6 (22–30): 9 expected"
echo "  ungated backlog (20–21, 31–42): 14"
echo

FAIL=0
if (( count != 42 )); then
  echo "FAIL: expected 42 on-disk fixtures, found $count"
  FAIL=1
fi
if (( missing_md > 0 )); then
  echo "WARN: $missing_md file(s) not referenced in FIXTURES.md"
  if (( STRICT )); then FAIL=1; fi
fi
if (( missing_on_disk > 0 )); then
  echo "FAIL: $missing_on_disk seq slot(s) missing on disk"
  FAIL=1
fi

if (( FAIL == 0 )); then
  echo "=== FIXTURE INVENTORY: PASS ==="
  exit 0
fi
echo "=== FIXTURE INVENTORY: FAIL ==="
exit 1
