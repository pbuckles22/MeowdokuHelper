# QA oracle audit — backward verification

How to detect and fix tests that may have been **Coder-tuned** (expectations changed to match implementation instead of spec/human oracle).

**Going forward:** [.cursor/rules/qa-coder-separation.mdc](../.cursor/rules/qa-coder-separation.mdc) blocks Coder from editing tests.

**Backward:** Git history + manifest + blind re-derivation. You cannot prove intent from git alone; you can **surface risk** and **re-lock** oracles independently.

---

## Three signals (use all three)

| Signal | What it catches | Tool |
|--------|-----------------|------|
| **Git coupling** | Same commit changed test/golden **and** solver/app code | `scripts/qa_oracle_audit.sh` |
| **Manifest provenance** | Oracle never independently verified | `doc/qa_oracle_manifest.yaml` |
| **Blind spec re-derivation** | Expectation wrong vs spec/human | QA session protocol (below) |

---

## Run the mechanical audit

```bash
./scripts/qa_oracle_audit.sh          # report (exit 0)
./scripts/qa_oracle_audit.sh --strict # exit 1 if P1/P2 still pending
```

Output:

- Coupled commits (QA paths + Coder paths in one commit)
- Manifest artifacts still `audit_status: pending`
- QA-owned files not listed in manifest
- Per-artifact **risk**: `high` (P1 + coupled), `medium`, `low`

Update `last_audit_run` in the manifest when a QA session completes a tranche.

---

## Blind re-derivation protocol (QA session only)

**Inputs allowed:** `solver_algorithms.md`, `product.md`, `FIXTURES.md`, uploaded JPEGs, parser output (`state`/`regions` from parse tests or one-off parse run).

**Inputs forbidden:** `tier*.rs`, `tier4.rs`, `calculate_next_move` / `calculateNextMove`, `*_fixtures.rs`, `*_goldens.dart`, existing `#[test]` assertion values.

### A — Solver synthetics (P3, co-located `#[test]`)

1. Read spec section only (e.g. Level 4 Phantom).
2. On paper or in `doc/qa_derivations/<artifact-id>.md`, write:
   - Minimal N×N board (state/regions)
   - **Expected observable** (cell X → BLOCKED; move index Y; illegal state)
   - Spec sentence that justifies it
3. **Then** open the `#[test]` module and compare.
4. **Match** → set manifest `audit_status: spec-verified`, `oracle: spec`.
5. **Mismatch** → do **not** edit test yet; open Coder session to fix implementation **or** fix derivation if spec was misread (QA edits test in QA session only).

### B — Fixture solve goldens (P1/P2)

1. Parse JPEG → lock `state`/`regions` (parse-lock is OK).
2. Human solve or manual trace → record `expected_move` in FIXTURES.md `Oracle: human` + derivation note.
3. Compare to `t6_fixtures.rs` / `grid_goldens.dart`.
4. **Match** → `audit_status: human-verified`.
5. **Mismatch** → Coder fixes solver; QA does not patch golden to match solver output.

### C — Regression-lock acceptance

If independent check is deferred but green must stay:

- Set `audit_status: regression-accepted`, `oracle: regression-lock-YYYY-MM-DD`
- **Not** correctness proof — document in FIXTURES.md

---

## Derivation notes (optional but recommended)

Store blind work under `doc/qa_derivations/` (tracked on git):

```
doc/qa_derivations/tier4-phantom-synthetics.md
doc/qa_derivations/t6-seq22-30-human.md
```

Template:

```markdown
# Derivation — <artifact-id>
**QA session:** YYYY-MM-DD
**Spec:** solver_algorithms.md § ...
**Forbidden inputs used:** none

## Board / fixture
...

## Expected (from spec/human only)
...

## Compare to locked test
- [ ] matches → spec-verified
- [ ] mismatch → escalate (solver fix or spec bug)
```

---

## Priority order (same as TEST_PLAN)

| P | Artifacts | Action |
|---|-----------|--------|
| P1 | t6 seq 22–30 solve goldens | Human/spec `expected_move` |
| P2 | seq 01–02 solve, integration smoke, `_T4_` fixtures | Human/spec + tier suffix |
| P3 | tier1–tier5 + DFS synthetics | Blind spec re-derivation |
| P4 | parse-only, FFI smoke | Spot-check on change |

**Do not** re-audit the entire suite in one session. One manifest `id` per QA session.

---

## What “spec-driven, no Coder touch” means in practice

| State | Meaning |
|-------|---------|
| `spec-verified` | QA re-derived from spec; compared to test; manifest updated |
| `human-verified` | Human oracle recorded; matches golden |
| `regression-accepted` | Known solver-capture; regression guard only |
| `pending` | **Not safe** to treat as independent proof |
| Coupled commit on file | **Suspicious** — prioritize blind re-derivation |

A test is **clean** only when manifest `audit_status` is `spec-verified` or `human-verified` (or `regression-accepted` with eyes open).

---

## After audit

1. Update `doc/qa_oracle_manifest.yaml` (`audit_status`, `oracle`, `last_verified`, `derivation: doc/qa_derivations/...`).
2. Update FIXTURES.md Oracle column for fixture rows.
3. Run `./scripts/qa_oracle_audit.sh --strict` before closing a QA audit epic/story.
4. Coder session only if derivation proved solver wrong — not to edit oracles.
