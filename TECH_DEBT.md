## Technical debt (tracked backlog)

This is the durable home for technical debt across sessions. Handoff notes can mention debt, but anything that persists should be recorded here.

### Cadence

- **Every handoff**: run the tech-debt-evaluator skill and record “Do first” items in the handoff note.
- **Promote persistent debt**: if a “Do first” item persists across 2+ handoffs (or blocks work), add it here and rank it.

---

## Fix now

(Blocking, unsafe, or no-rollback debt.)

- (none)

---

## Fix soon

(High ROI; frequent pain; not blocking.)

- **Blind oracle re-audit (QA session)** — Run `./scripts/qa_oracle_audit.sh`; follow [doc/QA_ORACLE_AUDIT.md](doc/QA_ORACLE_AUDIT.md); track in [doc/qa_oracle_manifest.yaml](doc/qa_oracle_manifest.yaml). **P1** t6 seq 22–30; **P2** integration + `_T4_` fixtures; **P3** co-located tier synthetics. 13 coupled QA+Coder commits on `main` (suspicious) — see audit script output.
- **Golden coverage** — seq 01–02 locked with solve indices; seq 03–08 have parse smoke tests (`parse_ladder_test.dart`) but **no locked goldens yet**; 24 fixtures still without parse+solve gates ([doc/plan/FIXTURES.md](doc/plan/FIXTURES.md)).
- **seq-08 N mismatch** — Catalog/fixture name says N=9; parser detects N=8 on `08_L09_N9_T1.jpg`. Integration test locks N=8 + index 11; fix N-detect when expanding goldens.
- **Integration fixture copy** — Four fixtures duplicated under `integration_test/fixtures/` for device `rootBundle`.
- **Android clipboard** — `pasteboard` may need FileProvider setup before device clipboard testing.
- **Wordle template remnants** — Archived `docs/` only; upstream template cleanup ([docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)).
- **Upstream FFI template** — Execute template cleanup plan; do not git-merge template into MeowdokuHelper.
- **Duplicate T6 golden data** — `t6_solver_goldens.dart` and `t6_fixtures.rs` mirror ~400 lines; golden codegen still needed.
- **Solver dedup (production)** — Test helpers deduped; production tier1/tier2 row/col/region iteration still duplicated; DFS paths not merged.
- **`calculate_next_move` clone-diff** — O(n²) per call; defer until EPIC-6.
- **Generated FRB doc comment** — `lib/src/rust/api/meowdoku.dart` still says "Tier-1"; fix Rust source comment + regenerate bindings.

## Accept for now

(Isolated + workaround + revisit trigger.)

- **Fixture `T` suffix vs ladder** — Relabel after EPIC-6 (Phase 6).
- **Solver O(n³) scans at N≤12** — Acceptable for 9×9/10×10 today.
- **`solve_parsed_grid.dart` pass-through** — Intentional test seam.
- **FFI tests skip when native lib absent** — Explicit skip via `test/support/native_ffi.dart`; Tier 2 validates on device.

---

## Audit remediation waves (2026-06-11)

Source: [PROJECT_HEALTH_AUDIT.md](.cursor/handoff/PROJECT_HEALTH_AUDIT.md).

| Wave | Status | Notes |
|------|--------|-------|
| **1** Docs + dead code | **Done** | README, DEV_GUIDE, TEST_TDD, QC_STATUS; deleted `80_chars_*.txt`; trimmed exceptions |
| **2** Test integrity | **Done** | Explicit FFI skip; seq 01–02 solve locked; `ffi_service_test.dart` |
| **3** Comment + copy | **Done** | Tier copy fixed; n_detect/solver/tier3 docs |
| **4** Structure | **Done** | `clipboard_flow.dart` extracted; `clipboard_flow_test.dart` |
| **5** Solver maintainability | **Partial** | `test_helpers.rs`; HashSet in locked sets; DFS merge + prod dedup deferred |
| **6** Coverage + SSOT | **Partial** | Error-path tests; parse ladder 03–08 smoke; TESTING_STRATEGY deprecated; full goldens + Tier 2 expansion remain |

**Next:** Lock parse goldens for seq 03–08; expand Tier 2 E2E; golden codegen Rust↔Dart.

---

## ROI rubric (quick)

Score each: Impact (0–2) + Frequency (0–2) + RiskReduction (0–2) + Effort (0–2, reverse scale). Sort descending.

| Item | Impact | Freq | Risk↓ | Effort | Score |
|------|--------|------|-------|--------|-------|
| Golden coverage seq 03–21 | 2 | 1 | 2 | 0 | **5** |
| Duplicate T6 goldens | 1 | 1 | 2 | 1 | **5** |
| Tier 2 E2E expansion | 2 | 1 | 2 | 1 | **6** |
| Prod solver dedup | 1 | 1 | 1 | 0 | **3** |
