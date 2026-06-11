# Epics and user stories — MeowdokuHelper

Maps to [PM_PLAN.md](../../PM_PLAN.md) phases. Story IDs: `US-<epic>.<n>`.

**Status:** Done | In progress | Planned

---

## EPIC-0 — Bootstrap · **Done**

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-0.1 | As a contributor, I can clone the repo and run agentic rules/skills without Wordle-specific drift. | Done | Template renamed; SDD in `doc/requirements/`; governance files present |

---

## EPIC-1 — Rust solver core (Tier 1) · **Done**

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-1.1 | As a player, the solver reasons about any N×N board via size-aware `Board`. | Done | `Board` with `idx`/`coord`; no hardcoded 9 |
| US-1.2 | As a player, Tier 1 applies halo blocking and naked singles until no change. | Done | `cargo test --lib` Tier 1 cases at N=9 |

---

## EPIC-1b — Remove Wordle template remnants · **Done**

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-1b.1 | As a contributor, the app and tests contain no Wordle UI, assets, or benchmarks. | Done | Placeholder shell; Wordle assets removed; `flutter test` green |
| US-1b.2 | As a developer, FFI exposes only Star Battle (`init_app`, `calculate_next_move`). | Done | Wordle `api/` removed; FRB regen; Tier 2 roundtrip green |
| US-1b.3 | As a contributor, Star Battle solver and board fixtures remain for later phases. | Done | `rust/src/solver/*`; `assets/test_fixtures/`; service locator pattern kept |

---

## EPIC-2 — Image pipeline · **Complete**

**Goal:** Clipboard screenshot → Dart isolate → `state` + `regions` `Uint8List` (length N²).

**Fixtures:** [FIXTURES.md](FIXTURES.md) — seq `01`–`32` (complexity order; L21–L33 at seq 20–32).

**Branch policy:** One feature branch per user story — `feature/us-{epic}.{story}-<slug>` (e.g. `feature/us-2.2-isolate`). Merge each story to `main` separately. **Handoff first:** complete [handoff checklist](../../.cursor/rules/handoff-checklist.mdc) before commit, push, or merge.

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-2.1 | As a developer, I can load and decode fixture JPEGs in unit tests. | Done | Test reads seq-01 fixture bytes; decode succeeds |
| US-2.2 | As a player, grid parsing runs off the UI thread in an isolate. | Done | `compute()` entrypoint; no jank on main isolate in test harness |
| US-2.3 | As a player, the app detects N from unique region colors. | Done | Unique-color count → N; array length N² |
| US-2.4 | As a player, each cell maps to region ID and cat/blocked/empty state. | Done | Center + offset sampling per product SDD |
| US-2.5 | As a developer, golden tests pass on easy fixtures before hard ones. | Done | seq `01` (N=4) + `02` (N=6) expected arrays locked |
| US-2.6 | As a player, pasting from clipboard on app focus triggers parsing. | Done | `pasteboard` on focus; same isolate path as fixtures |

**Next:** EPIC-3 — wire parse output → `calculateNextMove` → UI highlight

---

## EPIC-3 — End-to-end solve + highlight · **Done**

**Note:** FRB `calculate_next_move` shipped in EPIC-1b.

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-3.1 | As a player, parsed board state is sent to Rust and returns the next move index. | Done | `solveParsedGrid()` → `calculateNextMove` from clipboard parse in `main.dart` |
| US-3.2 | As a player, the suggested cell is highlighted on a minimal grid. | Done | `PuzzleGridPreview` — highlight ring or stalled banner |
| US-3.3 | As a developer, integration test covers image → parse → FFI → index. | Done | Tier 2: seq-08 fixture → `parseJpegInBackground` → `solveParsedGrid` → index 41 |

---

## EPIC-4 — Advanced solver tiers · **Done**

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-4.1 | As a player, Tier 2 intersection logic solves boards Tier 1 cannot. | Done | Region/line claims; `cargo test` intersection boards |
| US-4.2 | As a player, Tier 3 handles locked ecosystems and 2×2 traps. | Done | `cargo test` locked-set boards |
| US-4.3 | As a player, Tier 6 DFS finds moves or returns stuck safely (shipped as `tier4`). | Done | Complex boards; `-1` when truly stuck; no panic |
| US-4.4 | As a developer, T4 fixture gate locks seq 22–30 parse + solve regression. | Done | `t4_fixtures.rs` + `t4_solver_goldens.dart`; `cargo test` + `flutter test` |

---

## EPIC-5 — Progressive grid sizes (optional) · **Planned**

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-5.1 | As a player, 10×10 boards work end-to-end without code changes. | Planned | seq `14` (L15, N=10): parse → solve → highlight |
| US-5.2 | As a developer, N>9 is validated on multiple fixture sizes. | Planned | At least N=10 fixture full path green |

---

## EPIC-6 — Advanced deterministic tiers (optional) · **Planned**

Insert Phantom Cat Projection (T4) and Region Crowding (T5) before DFS; demote current DFS to T6. **Do not implement from prose alone** — follow [solver_algorithms.md](../requirements/solver_algorithms.md) exact steps.

| ID | Story | Status | Acceptance |
|----|-------|--------|------------|
| US-6.1 | As a player, Phantom Cat Projection blocks cells without guessing. | Planned | `tier4_phantom`; synthetic boards where T1–T3 stall, T4 deduces |
| US-6.2 | As a player, Region Crowding blocks traps before DFS. | Planned | `tier5`; synthetic boards where T1–T4 stall, T5 deduces |
| US-6.3 | As a developer, DFS is T6 only; fixture gates re-audited. | Planned | `run_tiers_1_through_6`; seq 22–30 still green; update `_T{n}_` suffixes where tier drops |

**Priority:** After EPIC-5. T4/T5 are performance/elegance, not correctness (T6 already sufficient).

---

## Traceability

| Epic | PM_PLAN phase |
|------|----------------|
| EPIC-0 | Phase 0 |
| EPIC-1 | Phase 1 |
| EPIC-1b | Phase 1b |
| EPIC-2 | Phase 2 |
| EPIC-3 | Phase 3 |
| EPIC-4 | Phase 4 (4a–4d) |
| EPIC-5 | Phase 5 |
| EPIC-6 | Phase 6 |
