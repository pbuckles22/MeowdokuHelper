# Test plan — MeowdokuHelper

Three-tier testing for Flutter-Rust FFI. Solver acceptance per [doc/requirements/product.md](doc/requirements/product.md).

---

## Tier 1a: Rust unit tests (fastest)

Pure Rust logic (algorithms, data processing, word filtering).

```bash
cd meowdoku_helper/rust
cargo test --lib
```

---

## Tier 1b: Flutter unit tests (fast)

Dart logic, widget smoke tests, and FFI init where the native library is available (see [docs/MAC_IOS_TEST.md](docs/MAC_IOS_TEST.md) — FFI smoke may skip on Windows).

```bash
cd meowdoku_helper
flutter test
```

---

## Tier 2: Integration tests (requires device/simulator)

End-to-end flows, UI interactions, and **real FFI** (native Rust lib linked via Xcode/Gradle).

**Required before merging any FFI or FRB change** — Tier 1b alone can skip native lib in the unit-test host.

```bash
cd meowdoku_helper
flutter test integration_test/ -d <ios-simulator-or-device-id>
```

See [docs/MAC_IOS_TEST.md](docs/MAC_IOS_TEST.md). Latest results: [doc/QC_STATUS.md](doc/QC_STATUS.md).

---

## Merge-ready gate

Run before **every code commit** and again before merge/push to `main`:

```bash
./scripts/merge_ready.sh
```

Equivalent manual steps (from `meowdoku_helper/`): `flutter analyze` → `flutter test` → `cd rust && cargo test --lib`.

**CI:** GitHub Actions [`.github/workflows/ci.yml`](.github/workflows/ci.yml) runs `merge_ready.sh` on Ubuntu (Tier 1) and `integration_test/app_smoke_test.dart` on macOS (Tier 2). After push, `gh run watch` per handoff checklist.

**FFI / FRB changes:** also run Tier 2 on iOS simulator locally ([docs/MAC_IOS_TEST.md](docs/MAC_IOS_TEST.md)) if macOS CI is unavailable.

**Phase 7 oracle gate (QA sessions only):** `./scripts/qa_oracle_audit.sh --strict` — fails while P1/P2 manifest items are `pending`; not part of default CI until Phase 7 closes.

**TDD:** new behavior requires **red → green** at the applicable tier(s) before merge; then re-run the full gate above so nothing else regressed.

**Handoff:** Document the exact commands you use for coverage in AGENT_HANDOFF.md so agents can run them consistently.

---

## Technical settlement (before handoff)

All technical work must be **settled** before the peer handoff note. Order:

1. Phase A — review, tech debt, merge-ready gate (+ Tier 2 when required) — [.cursor/rules/handoff-checklist.mdc](.cursor/rules/handoff-checklist.mdc)
2. Update **tracked docs** (`PM_PLAN`, `PROJECT_STATUS`, `AGENT_HANDOFF`)
3. Phase B — commit → push → merge → **CI verify** (`gh run watch` when Actions exist)
4. Phase C — **last:** write gitignored `.cursor/handoff/` note with CI URL/conclusion for copy-paste to the next agent

The handoff note is not checked in. CI (or confirmed local gate on `main`) is the final technical gate; the handoff summarizes settled work for peers.

---

## QA / Coder separation (mandatory)

**Goal:** Two minds that **only meet at test time**. QA does not design solutions; Coder does not pick oracles or assign fixture expectations.

### Roles

| Role | Owns | Must NOT read / do |
|------|------|---------------------|
| **QA** | Tests, oracles, fixture assignment, expected outcomes, tier-gate labels | Implementation source (`tier*.rs`, solver internals), "make it pass" tuning of goldens |
| **Coder** | Production code to satisfy **existing** failing tests | Writing or changing test expectations, picking screenshot→tier mapping, capturing solve indices from own solver |

Use a **fresh agent session** (or explicit role switch) when crossing the line. Same chat/session implementing a tier **and** locking fixture solve goldens is **forbidden**.

### Allowed inputs

**QA may read:** [doc/requirements/solver_algorithms.md](doc/requirements/solver_algorithms.md), [doc/requirements/product.md](doc/requirements/product.md), [doc/plan/FIXTURES.md](doc/plan/FIXTURES.md), [PM_PLAN.md](PM_PLAN.md), user-uploaded assets under `assets/test_fixtures/`, **parse output only** (`state`/`regions` from parser — not solver source).

**Coder may read:** Specs for intent, plus all implementation. Coder runs tests but **must not edit QA-owned files** — see hard rule below.

### Coder must not change tests (hard rule)

**Not merely implied.** In Coder role, QA-owned paths are **read-only**, including when the test does not match your implementation or you believe the oracle is wrong.

| Forbidden for Coder | Why |
|-------------------|-----|
| Edit `test/**`, `integration_test/**` expectations | Self-grading |
| Edit `*_goldens.dart`, `*_fixtures.rs` | Oracle capture |
| Edit FIXTURES.md oracle/tier columns | Assignment bleed |
| Change `#[test]` expectations in `tier*.rs` | Same-session bleed |

**If a test fails:** fix production code only. Still failing → **stop and escalate** to QA (fresh session) or user oracle — document actual vs expected; do not patch the test.

Enforced in [.cursor/rules/qa-coder-separation.mdc](.cursor/rules/qa-coder-separation.mdc) (`alwaysApply`).

### Touch points (only at test time)

1. **QA writes failing test** (red) — synthetic board from spec, or fixture row with oracle recorded in FIXTURES.md.
2. **Handoff test artifact to Coder** — test file paths + oracle source; no implementation hints.
3. **Coder implements** until tests green — **zero** edits to QA-owned paths.
4. **Persistent failure** — QA re-checks oracle (spec/human) in a **new session**; adjusts test or files spec bug. Coder waits; does not "fix" `expected_move` to match implementation.

### Oracle types (FIXTURES.md)

| Type | Source | Use |
|------|--------|-----|
| **spec** | Minimal board + outcome from `solver_algorithms.md` | Tier unit synthetics (QA writes) |
| **human** | Human solve or manual trace on screenshot | Fixture `expected_move` |
| **parse-lock** | Parser output at lock date | Parse golden arrays |
| **regression-lock** | Prior independent oracle, frozen | Regression only — not correctness proof |

**Forbidden:** Capturing `expected_move` from `calculate_next_move` / `calculateNextMove` in the same session that wrote or changed the solver under test. That is regression-lock at best; label it and schedule independent re-audit.

**Forced-move uniqueness (QA):** Block candidate cell; if solver still returns a next move, classify **BRANCH_VARIANT** (not a hint oracle). Implementation: `rust/src/solver/t6_qa_force.rs`, `test/qa_t6_oracle_audit_test.dart`. seq 22–30: 0/9 forced (2026-06-12).

### Workflows

**New tier algorithm (e.g. T4 Phantom):**

1. QA: synthetic `#[test]` from spec → red.
2. Coder: implement → green.
3. QA (separate session): assign fixture seq + minimum tier suffix from specs + JPEGs only.
4. QA (separate session): record `expected_move` via **human** or trusted reference — not solver output.
5. Coder: wire fixture gate; if mismatch, fix solver — not oracle.

**Fixture re-gate (suffix rename, new seq):**

1. QA: tier assignment + oracle column in FIXTURES.md **before** Coder touches `*_fixtures.rs` / `*_goldens.dart`.
2. Coder: implementation only after QA artifacts exist.

### QA-owned vs Coder-owned paths

| QA-owned | Coder-owned |
|----------|---------------|
| `test/*_fixture_gate_test.dart` expectations | `rust/src/solver/tier*.rs` |
| `rust/src/solver/*_fixtures.rs` oracle arrays | `lib/app/`, `lib/image/` (except golden capture) |
| `lib/image/*_solver_goldens.dart` (generated) | Mechanical output of `./scripts/generate_solver_goldens.sh` |
| FIXTURES.md oracle / tier columns | |

Golden **codegen** runs from QA-approved oracle SSOT only (`rust/src/solver/*_fixtures.rs` → `./scripts/generate_solver_goldens.sh` → `lib/image/*_solver_goldens.dart`).

See [.cursor/skills/tester/SKILL.md](.cursor/skills/tester/SKILL.md) and [.cursor/skills/TEST_TDD.md](.cursor/skills/TEST_TDD.md).

---

## Blind re-audit (existing suite)

**Not required:** Re-run every test in a blind session today.

**Required going forward:** All **new** tests follow QA/Coder separation above.

**Backward audit (already-shipped tests):** [doc/QA_ORACLE_AUDIT.md](doc/QA_ORACLE_AUDIT.md) + manifest [doc/qa_oracle_manifest.yaml](doc/qa_oracle_manifest.yaml).

```bash
./scripts/qa_oracle_audit.sh          # report: git coupling + manifest pending
./scripts/qa_oracle_audit.sh --strict # fail if P1/P2 still pending
```

Three signals: **git coupling** (test+code same commit), **manifest provenance** (`audit_status`), **blind spec re-derivation** (QA session without solver source).

A test is **spec-clean** only when manifest says `spec-verified` or `human-verified`. `pending` / `regression-lock` = not independent proof.

**Prioritized re-audit backlog** (one manifest `id` per QA session):

| Priority | Scope | Why |
|----------|-------|-----|
| P1 | Solve goldens seq 22–30 (`t6_*`) | `expected_move` captured from solver at lock time |
| P2 | seq 01–02 solve, integration smoke, `_T4_` fixtures | Regression-lock or coupled commits |
| P3 | Synthetic tier `#[test]` modules | Co-located with implementation; re-derive from spec only |
| P4 | Parse goldens seq 01–02, FFI smoke | Parser regression; spot-check on change |

Record blind work in `doc/qa_derivations/`; update manifest after each session.
