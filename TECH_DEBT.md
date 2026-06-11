## Technical debt (tracked backlog)

This is the durable home for technical debt across sessions. Handoff notes can mention debt, but anything that persists should be recorded here.

### Cadence

- **Every handoff**: run the tech-debt-evaluator skill and record “Do first” items in the handoff note.
- **Promote persistent debt**: if a “Do first” item persists across 2+ handoffs (or blocks work), add it here and rank it.

---

## Fix now

(Blocking, unsafe, or no-rollback debt.)

- (none)

## Fix soon

(High ROI; frequent pain; not blocking.)

- **Parser tuning** — N-detect / cell-sampling thresholds tuned for JPEG fixtures; may need adjustment for PNG or new capture formats.
- **Golden coverage** — seq 01+02 locked; expand up fixture order as parser evolves ([doc/plan/FIXTURES.md](doc/plan/FIXTURES.md)).
- **seq-08 N mismatch** — Catalog/fixture name says N=9; parser detects N=8 on `08_L09_N9_T1.jpg`. Integration test locks N=8 + index 41; fix N-detect when expanding goldens (image pipeline).
- **Integration fixture copy** — seq-08 duplicated under `integration_test/fixtures/` (~100KB) for device `rootBundle`; repo-root `assets/test_fixtures/` remains Tier 1 source of truth.
- **Android clipboard** — `pasteboard` may need FileProvider setup before device clipboard testing.
- **Wordle template remnants** — Rust FRB Wordle API removed (1b.2). **Remaining:** legacy Wordle mentions in archived `docs/`; upstream template cleanup ([docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md)).
- **Upstream FFI template** — [Rust_Julia_FFI_Flutter_Template](https://github.com/pbuckles22/Rust_Julia_FFI_Flutter_Template) still contains Wordle bolt-on; execute [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md) so future bolt-ons start clean. Do not git-merge template into MeowdokuHelper.

## Accept for now

(Isolated + workaround + revisit trigger.)

- **Fixture `T` suffix vs ladder** — Filenames use `_T4_` for “needs DFS today.” Target T1–T6 ladder documented in [solver_algorithms.md](doc/requirements/solver_algorithms.md); relabel after EPIC-6 (Phase 6).

---

## ROI rubric (quick)

Score each: Impact (0–2) + Frequency (0–2) + RiskReduction (0–2) + Effort (0–2, reverse scale). Sort descending.

