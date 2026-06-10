# QC status — MeowdokuHelper

**Tracked quality gate record** (for humans and agents when auto-review obscures history).

**Last QC run:** 2026-06-10  
**Branch:** `bump/flutter-rust-bridge-2.12` @ `0e02c02`  
**Base:** `main` @ `9ff7744` (local; **not pushed** to `origin`)

---

## Ship status

| Item | Status |
|------|--------|
| Tier 1a `cargo test --lib` | **PASS** — 18 tests |
| Tier 1b `flutter test` | **PASS** — 6 tests |
| `flutter analyze` | **PASS** — no issues |
| Tier 2 iOS 26.5 simulator | **PASS** — 2 integration tests |
| FRB 2.12 bump committed | **YES** — `0e02c02` |
| FRB bump merged to `main` | **NO** — on feature branch |
| `git push origin` | **NO** |

---

## Tier 2 — required now?

**Yes, for FFI changes.** Tier 2 is the authoritative **Dart → Rust → Dart** proof on a real native build (Xcode + simulator).

Command (iOS 26.5 simulator):

```bash
cd meowdoku_helper
flutter test integration_test/ -d <ios-26.5-simulator-id>
```

**2026-06-10 result:** both tests passed:

1. `app launches placeholder shell` — `RustLib.init()` via app bootstrap, pets icon
2. `rust bridge returns computed response` — `simulateGuessPattern` → `GGGXG` / `XXGXG`

Tier 1b alone is **not sufficient** for FFI (unit host may skip native lib). Tier 2 **must stay green** before merging FFI work.

---

## Skills / checklist (handoff protocol)

| Step | Skill | This run |
|------|--------|----------|
| Tests | tester + TEST_PLAN | **Done** — all tiers above |
| Code review | code-reviewer | **Done** — see below |
| Tech debt | tech-debt-evaluator | **Done** — see below |
| Security | security-reviewer | **N/A** — no creds/network changes |
| Docs | techwriter / PROJECT_STATUS | **Partial** — this file + prior status updates |
| Push | AGENT_HANDOFF git workflow | **Pending** |

---

## Code review (FRB 2.12 + integration line)

**Verdict: PASS with WARN**

| Area | Result |
|------|--------|
| FRB pins aligned (Dart + Rust 2.12.0) | PASS |
| Bindings regenerated, not hand-edited | PASS |
| Roundtrip tests cover call + response | PASS |
| Merge-ready gate | PASS |
| Codegen duplicate-symbol warnings (`IntelligentSolver` in two modules) | WARN — pre-existing Wordle API; harmless until Wordle modules removed |
| Wordle API still in `rust/src/api/` | WARN — intentional per PM_PLAN 1b.2 deferral; see Wordle section |

---

## Tech debt (prioritized)

| Severity | Item | Action |
|----------|------|--------|
| High | ~2,600 lines Wordle Rust in `rust/src/api/` + generated FRB surface | Phase 1b.2 / Phase 3: replace with `init_app` + `calculate_next_move`, delete `meowdoku_helper*.rs`, regenerate |
| Medium | Tier 1b FFI tests can pass vacuously if native lib missing | Keep Tier 2 mandatory for FFI PRs |
| Medium | `main` + bump branch not pushed to `origin` | Push after merge approval |
| Low | Stale comments ("Wordle") in exceptions / service_locator | Clean during API gut |
| Low | Upstream template Wordle | [docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md](../docs/TEMPLATE_WORDLE_CLEANUP_PLAN.md) |

---

## Wordle gutting — what’s done vs what remains

### Removed (Phase 1b.1 — done)

- Flutter UI, models, controllers, widgets, game services
- Wordle assets (`official_wordle_words.json`, guess word list)
- ~45 Wordle Dart tests, benchmarks, device perf scripts
- Rust benchmarking binaries/modules

### Still in repo (Phase 1b.2 — **deliberately kept**)

| Path | ~Lines | Why it exists |
|------|--------|----------------|
| `rust/src/api/meowdoku_helper.rs` | 580 | Wordle solver + `WORD_MANAGER` — still exported via FRB |
| `rust/src/api/meowdoku_helper_reference.rs` | 261 | Reference Wordle solver |
| `rust/src/api/simple.rs` | 893 | `init_app`, `get_best_guess`, `simulate_guess_pattern`, etc. |
| `lib/src/rust/**` (generated) | large | FRB bindings for above — **never edit by hand** |
| `rust/src/frb_generated.rs` | large | Same |

### Star Battle product code (small, not yet on FRB)

| Path | ~Lines |
|------|--------|
| `rust/src/solver/` | ~286 |

**PM_PLAN** defers removing Wordle **FFI exports** until Phase 3 swaps in `calculate_next_move`. UI/assets/tests are gutted; **the bridge still speaks Wordle** because that was the template API used to keep FFI alive.

To **fully gut Wordle in this repo:** one focused branch — delete Wordle `api/` modules, add minimal Star Battle FRB API (`init_app` + roundtrip test function or `calculate_next_move` stub), `flutter_rust_bridge_codegen generate`, fix Rust tests, Tier 1 + Tier 2 green. **No new skill required** — use `pm-governance` + `tech-lead` + `github-feature-workflow` + existing handoff checklist.

---

## Next actions

1. Merge `bump/flutter-rust-bridge-2.12` → `main` after approval
2. `git push origin main` (and feature branch if retained)
3. Branch `cleanup/wordle-api` (or Phase 3): remove Wordle FRB surface, wire solver stub
4. Keep Tier 2 in merge-ready gate for every FFI-touching PR
