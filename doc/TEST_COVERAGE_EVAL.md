# Test coverage evaluation — TL + QA

**Date:** 2026-06-11  
**Branch:** `main` @ EPIC-6 complete  
**Gate:** Tier 1 green — 50 Flutter passed (+15 FFI skip), 28 Rust `cargo test --lib`  
**Process:** QA/Coder separation + oracle manifest now in place ([TEST_PLAN.md](../TEST_PLAN.md), [QA_ORACLE_AUDIT.md](QA_ORACLE_AUDIT.md))

This doc is the **joint TL + QA** read on what we test well, what is weak/wrong, and what is missing. It is not line-coverage % (no `lcov`/llvm-cov wired); it is **behavior × fixture × oracle** coverage.

---

## Executive summary

| Dimension | Verdict |
|-----------|---------|
| **Merge gate / TDD discipline** | **Good** — Tier 1a+1b green; red-green culture; QA/Coder hard boundary added |
| **Solver core behavior** | **Strong** — T1–T6 synthetics + seq 22–30 gate |
| **Oracle independence** | **Weak** — 9/12 manifest artifacts `pending`; P1 solve goldens are regression-lock |
| **Fixture catalog (42 JPEGs)** | **Thin** — 2 parse goldens; 9 solve gate; 4 Tier 2; **30 fixtures untested** |
| **Tier 2 post–EPIC-6** | **Stale** — needs iOS sim re-run |

**TL call:** Do not start new solver epics until **QA audit wave 1** (P1 + Tier 2) completes. Process is settled; **oracle proof** is the gap.

---

## Tested right (keep and extend)

### Solver ladder (Tier 1a)

| Area | Tests | Why it's right |
|------|-------|----------------|
| T1–T3 | `tier1.rs`–`tier3.rs` `#[test]` | Spec-shaped minimal boards; stall→escalation patterns |
| T4 Phantom | `tier4_phantom.rs` (3 tests) | Intersection blocking per Level 4 spec |
| T5 Crowding | `tier5.rs` (3 tests) | Phantom-stall → crowding path |
| T6 DFS | `tier4.rs` + orchestrator tests | Bifurcation when T1–T5 stall |
| seq 22–30 gate | `t6_fixtures.rs` + `t6_fixture_gate_test.dart` | Real screenshots; parse + solve locked both sides |

### Image pipeline (Tier 1b)

| Area | Tests | Why it's right |
|------|-------|----------------|
| seq 01–02 | `grid_golden_test.dart` | Locked `state`/`regions` — parser regression |
| seq 03–08 | `parse_ladder_test.dart` | Parse smoke (N² validity) |
| N-detect, JPEG, isolate | `n_detect_test.dart`, `decode_isolate_test.dart`, etc. | Black-box pipeline units |
| Error paths | `*_error_test.dart`, `board_fixture_error_test.dart` | Fail-fast behavior |

### FFI + app seam (Tier 1b / 2)

| Area | Tests | Why it's right |
|------|-------|----------------|
| FFI init / skip | `native_ffi.dart`, `ffi_service_test.dart` | Explicit skip when lib absent (not silent pass) |
| Roundtrip | `rust_ffi_roundtrip_test.dart` | Synthetic choke board via FRB |
| Clipboard flow | `clipboard_flow_test.dart` | Parse→solve status strings incl. Tiers 1–6 |
| Device E2E | `integration_test/app_smoke_test.dart` (6) | Real isolate + FFI on seq 08, 14, 29, 30 |

---

## Tested wrong / weak (fix oracle or assertion strength)

| Issue | Location | QA verdict | Fix |
|-------|----------|------------|-----|
| **Solver-captured solve indices** | `t6_*`, `grid_goldens` expectedMove, integration `expectedMoveIndex` | Regression-lock, not proof | P1/P2 blind human/spec re-audit |
| **Co-located tier synthetics** | `tier*.rs` `#[cfg(test)]` | `unaudited` — implementer bleed risk | P3 spec re-derivation per manifest id |
| **13 coupled QA+Coder commits** | `main` git history | Suspicious same-slice test+code edits | `./scripts/qa_oracle_audit.sh`; don't repeat |
| **Parse ladder too weak** | `parse_ladder_test.dart` | Only range checks, not locked arrays | QA lock goldens seq 03–08 (D3) |
| **Catalog N vs parser N** | seq 08 (`N9` name, N=8 parsed) | Documented mismatch — oracle ambiguity | Fix N-detect or rename; re-lock integration oracle |
| **No T2/T3 fixture gate** | seq 09–19 | Tier suffix in filename untested | QA assigns oracles → new gate tests |
| **seq 18–21, 31–42** | `_T4_` historical | No solve gate; tier unverified | P2 audit when re-gating |

**Important:** Tests are **not wrong because they're red**. They're **weak as correctness proof** until manifest shows `spec-verified` or `human-verified`.

---

## Missing tests (prioritized by product risk)

### P0 — Process / gate

| # | Story | Owner | DoD |
|---|-------|-------|-----|
| Q1 | P1 blind audit `t6-fixture-gate` | QA | `doc/qa_derivations/t6-seq22-30-human.md`; manifest `human-verified` |
| Q2 | Tier 2 iOS re-run post–EPIC-6 | TL | 6 integration tests green; QC_STATUS updated |

### P1 — Fixture coverage

| # | Gap | Fixtures | Suggested test |
|---|-----|----------|----------------|
| M1 | Parse goldens | seq 03–08 | Extend `grid_goldens.dart` + `grid_golden_test.dart` |
| M2 | T2/T3 solve gate | seq 09–19 | New `t2_t3_fixture_gate_test.dart` (QA oracles first) |
| M3 | T4/T6 expansion | seq 20–21, 31–42 | Extend gate after QA tier audit |
| M4 | Parse-only for 31–42 | 12 JPEGs | At minimum parse smoke loop |

### P2 — API / UI

| # | Gap | File |
|---|-----|------|
| M5 | FRB API synthetic | `rust/src/api/meowdoku.rs` — trap board at API boundary |
| M6 | Preview cells | `puzzle_grid_preview_test.dart` — cat/blocked icons |
| M7 | Main shell FSM | `main_shell_test.dart` / clipboard — full paste journey |

### P3 — Tooling (optional)

| # | Gap | Notes |
|---|-----|-------|
| M8 | Line coverage % | `cargo llvm-cov`, `flutter test --coverage` — not wired; behavior matrix is current SSOT |

---

## Coverage snapshot (fixture × tier)

**42 fixtures** in [FIXTURES.md](plan/FIXTURES.md):

| Coverage type | Count | Seq |
|---------------|-------|-----|
| Parse golden (locked arrays) | 2 | 01–02 |
| Parse smoke only | 6 | 03–08 |
| Solve golden (Tier 1) | 11 | 01–02 + 22–30 |
| Tier 2 E2E solve | 4 | 08, 14, 29, 30 |
| **No automated gate** | **30** | 09–07 gap, 09–21, 31–42 |

**Rust:** 28 unit tests (solver-heavy).  
**Flutter:** 21 test files; 50 assertions passed host-side.  
**Integration:** 6 widget tests on device/sim.

---

## QA manifest status (oracle proof)

Run: `./scripts/qa_oracle_audit.sh`

| audit_status | Count | Artifacts |
|--------------|-------|-----------|
| `pending` | 9 | t6 gate, integration, phase2 solve, tier1–5 + DFS synthetics |
| `regression-accepted` | 3 | parse goldens 01–02, parse ladder, FFI |

`--strict` fails until P1/P2 cleared.

---

## TL sequenced work (recommended epic: QA hardening)

| Order | Story | Role | Validation |
|-------|-------|------|------------|
| 1 | Q1 — P1 t6 human audit | QA | manifest + FIXTURES Oracle column |
| 2 | Q2 — Tier 2 iOS | TL/Tester | `integration_test/` green |
| 3 | Q3 — P3 tier synthetics batch (one tier/session) | QA | `spec-verified` in manifest |
| 4 | M1 — Lock parse goldens 03–08 | QA writes → Coder if parser fix | `grid_golden_test` |
| 5 | M2 — T2/T3 gate seq 09–19 | QA oracles → Coder wires | new gate test file |
| 6 | P2 integration + seq 01–02 solve audit | QA | `human-verified` |
| 7 | M3 — Remaining `_T4_` fixtures | QA | per FIXTURES re-audit |

**Definition of done for “TDD settled”:** Process rules enforced + P1/P2 manifest clear + Tier 2 green — not 100% of 42 fixtures gated.

---

## References

- [TEST_PLAN.md](../TEST_PLAN.md)
- [doc/qa_oracle_manifest.yaml](qa_oracle_manifest.yaml)
- [doc/QA_ORACLE_AUDIT.md](QA_ORACLE_AUDIT.md)
- [PROJECT_HEALTH_AUDIT.md](../.cursor/handoff/PROJECT_HEALTH_AUDIT.md) (2026-06-11 baseline)
