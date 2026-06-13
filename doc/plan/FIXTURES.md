# Board screenshot fixtures

Repo root: `assets/test_fixtures/`

## Naming convention

```
{seq:02d}_L{gameLevel}[_N{grid}][_T{tier}].{jpg|jpeg}
```

| Part | Meaning |
|------|---------|
| `seq` | **Complexity tackle order** — satisfy parse/solve tests in this sequence (not game level order) |
| `L{gameLevel}` | In-game level from screenshot header: `L-early`, `L03` … `L33` |
| `N{grid}` | Grid size N×N when known |
| `T{tier}` | Solver gate: minimum tier (1–6 target ladder) before E2E solve must pass |

**Tier suffix (seq 22–30 gate):** Filenames use `_T6_` — minimum tier = DFS after EPIC-6. Other `_T4_` fixtures (seq 18–21, 31–42) retain historical suffix until individually re-audited.

**Legacy names** (`EarlyGame.jpg`, `lvl3.jpg`, UUID exports) are retired.

**Inventory:** `./scripts/fixture_inventory.sh` — seq 01–42 on-disk vs gate tier + FIXTURES.md catalog (H3 2026-06-12).

## Oracle protocol (QA-owned)

Fixture gates follow [TEST_PLAN.md](../../TEST_PLAN.md) → **QA / Coder separation**. Summary:

- **Tier suffix** and **expected_move** are assigned by **QA** from specs + assets + human/reference — not from reading solver source or capturing `calculate_next_move` in the same session that implements the solver.
- Record oracle provenance in the **Oracle** column when locking a row (below).
- **Coder** must not edit `*_goldens.dart`, `*_fixtures.rs`, or gate test expectations to force green.

| Oracle value | Meaning |
|--------------|---------|
| `spec` | Synthetic minimal board; outcome from `solver_algorithms.md` |
| `human` | Human solve or manual trace on screenshot |
| `parse-lock-YYYY-MM-DD` | Parser `state`/`regions` frozen at date |
| `regression-lock-YYYY-MM-DD` | Solve index frozen from prior solver run — regression only; schedule independent re-audit |

**Blind re-audit backlog:** seq 22–30 solve goldens (P1); seq 18–21, 31–42 tier+move (P2). See TEST_PLAN.md → Blind re-audit.

## Two axes

1. **Pipeline (Phase 2)** — parse difficulty: smaller N first (seq 01–08).
2. **Solver (Phase 4–6)** — algorithm tier per [solver_algorithms.md](../requirements/solver_algorithms.md). Target ladder T1–T6; shipped code is T1–T3 + DFS (historical T4).

**Seq 20+** orders by **solver complexity** (forced singles → grid size → region sprawl → ★HARD), not by game level number. Example: seq **21** is L26 (8×8, easy anchors) before seq **23** is L22 (9×9).

## Catalog — seq 01–19 (original batch)

| Seq | File | Game | Grid N | Solver gate | Oracle | Notes |
|-----|------|------|--------|-------------|--------|-------|
| 01 | `01_L-early_N4_T1.jpg` | tutorial | 4 | T1 | human | Phase 2 golden; Q6 spec T1 verified |
| 02 | `02_L03_N6_T1.jpg` | 3 | 6 | T1 | human | Phase 2 golden; Q6 spec T1 verified |
| 03 | `03_L04_T1.jpg` | 4 | 6 | T1 | parse-lock | Phase 2 golden (Q4 2026-06-12) |
| 04 | `04_L05_T1.jpg` | 5 | 10 | T1 | parse-lock | Phase 2 golden (Q4 2026-06-12) |
| 05 | `05_L06_T1.jpg` | 6 | 6 | T1 | parse-lock | Phase 2 golden (Q4 2026-06-12) |
| 06 | `06_L07_T1.jpg` | 7 | 5 | T1 | parse-lock | Phase 2 golden (Q4 2026-06-12) |
| 07 | `07_L08_T1.jpg` | 8 | 7 | T1 | parse-lock | Phase 2 golden (Q4 2026-06-12) |
| 08 | `08_L09_N9_T1.jpg` | 9 | 8 | T1 | regression-lock | Phase 2 golden; Tier 2 E2E (Q6 regression-accepted) |
| 09 | `09_L10_N7_T2.jpg` | 10 | 7 | T2 | regression-lock | Q5 gate 2026-06-12 |
| 10 | `10_L11_T2.jpeg` | 11 | 6 | T2 | regression-lock | Q5 gate 2026-06-12 |
| 11 | `11_L12_T2.jpeg` | 12 | 6 | T2 | regression-lock | Q5 gate 2026-06-12 |
| 12 | `12_L13_T2.jpeg` | 13 | 9 | T2 | regression-lock | Q5 gate 2026-06-12 |
| 13 | `13_L14_T2.jpeg` | 14 | 9 | T2 | regression-lock | Q5 gate 2026-06-12 |
| 14 | `14_L15_N10_T3.jpeg` | 15 | 12 | T3 | regression-lock | Parser N=12 (not 10); Q5 gate |
| 15 | `15_L16_T3.jpeg` | 16 | 9 | T3 | regression-lock | Q5 gate 2026-06-12 |
| 16 | `16_L17_T3.jpeg` | 17 | 10 | T3 | regression-lock | Q5 gate 2026-06-12 |
| 17 | `17_L18_T3.jpeg` | 18 | 10 | T3 | regression-lock | Q5 gate 2026-06-12 |
| 18 | `18_L19_T4.jpeg` | 19 | 10 | T4 | regression-lock | H2 gate 2026-06-12 |
| 19 | `19_L20_T4.jpeg` | 20 | 9 | T4 | regression-lock | H2 gate 2026-06-12; gate before seq 20+ batch |

## Catalog — seq 20–32 (L21–L33 batch)

Added June 2026. **Start after seq 19 (`L20`) parses and solves.** One duplicate L25 export dropped.

| Seq | File | Game | Grid N | Solver gate | Oracle | Complexity rationale |
|-----|------|------|--------|-------------|--------|----------------------|
| 20 | `20_L21_N8_T3.jpeg` | 21 | 8 | T3 | regression-lock-2026-06 | 2 single-cell regions; refreshed capture |
| 21 | `21_L26_N8_T4.jpeg` | 26 | 8 | T4 | regression-lock-2026-06 | 2 forced singles; smallest N in batch |
| 22 | `22_L31_N8_T6.jpeg` | 31 | 8 | T6 | regression-lock-2026-06 | 2 forced singles — **P1 re-audit** |
| 23 | `23_L22_N9_T6.jpeg` | 22 | 9 | T6 | regression-lock-2026-06 | 1 forced single (purple) — **P1** |
| 24 | `24_L27_N9_T6.jpeg` | 27 | 9 | T6 | regression-lock-2026-06 | 1 forced single + tight cascades — **P1** |
| 25 | `25_L32_N9_T6.jpeg` | 32 | 9 | T6 | regression-lock-2026-06 | 2 forced singles — **P1** |
| 26 | `26_L29_N9_T6.jpeg` | 29 | 9 | T6 | regression-lock-2026-06 | 1 forced single — **P1** |
| 27 | `27_L24_N9_T6.jpeg` | 24 | 9 | T6 | regression-lock-2026-06 | Small regions; no singleton — **P1** |
| 28 | `28_L30_N9_T6.jpeg` | 30 | 9 | T6 | regression-lock-2026-06 | ★HARD — defer despite singleton — **P1** |
| 29 | `29_L23_N10_T6.jpeg` | 23 | 10 | T6 | regression-lock-2026-06 | 2 singles; large fragmented regions — **P1** |
| 30 | `30_L25_N10_T6.jpeg` | 25 | 10 | T6 | regression-lock-2026-06 | 1 single; sprawling regions — **P1** |
| 31 | `31_L28_N10_T4.jpeg` | 28 | 10 | T4 | Smallest region = 2 cells; no singleton |
| 32 | `32_L33_N10_T4.jpeg` | 33 | 10 | T4 | Largest sprawl; last in batch |

## Catalog — seq 33–41 (L34–L52 batch)

Added June 2026. Deduped from UUID exports; levels already in seq 01–32 were removed.

| Seq | File | Game | Grid N | Solver gate | Notes |
|-----|------|------|--------|-------------|-------|
| 33 | `33_L34_N9_T4.jpeg` | 34 | 9 | T4 | |
| 34 | `34_L35_N10_T4.jpeg` | 35 | 10 | T4 | |
| 35 | `35_L39_N9_T4.jpeg` | 39 | 9 | T4 | |
| 36 | `36_L41_N9_T4.jpeg` | 41 | 9 | T4 | Parser N=9 |
| 37 | `37_L42_N9_T4.jpeg` | 42 | 9 | T4 | |
| 38 | `38_L43_N10_T4.jpeg` | 43 | 10 | T4 | |
| 39 | `39_L44_N9_T4.jpeg` | 44 | 9 | T4 | |
| 40 | `40_L51_N8_T4.jpeg` | 51 | 8 | T4 | |
| 41 | `41_L52_N10_T4.jpeg` | 52 | 10 | T4 | |

## Catalog — seq 42 (L50)

| Seq | File | Game | Grid N | Solver gate | Notes |
|-----|------|------|--------|-------------|-------|
| 42 | `42_L50_N9_T4.jpeg` | 50 | 9 | T4 | ★HARD header in screenshot |

**Phase 2 golden minimum:** seq **01** + **02**.

**Phase 3 E2E:** seq **08** (N=9).

**Phase 5 N>9:** seq **14**, then seq **29**–**32**.

Solver gate tiers are **QA estimates** from specs and board shape — re-audit with independent oracle before treating as proof. Rows marked `regression-lock` are regression guards only, not independent correctness proof.

## Reserved (seq 43+)

Future in-app levels (gaps: L36–L38, L40, L45–L49, L53+). Use `{seq:02d}_L{level}[_N{n}]_T{tier}.jpeg`.

## Reference assets (not parse fixtures)

Under `assets/reference/` — **UX targets**, not fed through the parse/solve pipeline. Annotated screenshots showing how hints should look in-app.

| File | Purpose | Maps to |
|------|---------|---------|
| `hint_t5_region_crowding_column5.jpeg` | Human hint + multi-cell highlights | EPIC-6 **T5** Region Crowding — copy: *"Placing here excludes all cells in Column 5 – no cat can be placed"*. Shows hypothetical **Cat?** on one cell (yellow border) and **blocked** cells in the crowding path (green/yellow borders). Target UI: short plain-language rule name + explanation + highlight ring(s), not just a single next-cat index. |

When hint UI ships, add acceptance criteria against this reference ([product.md](../requirements/product.md) — future hint panel).

## Missing from app

`L01`, `L02` — not captured. Seq **01** (`L-early`) is pre-L03.
