# Board screenshot fixtures

Repo root: `assets/test_fixtures/`

## Naming convention

```
{seq:02d}_L{gameLevel}[_N{grid}][_T{tier}].{jpg|jpeg}
```

| Part | Meaning |
|------|---------|
| `seq` | Master work order — **satisfy tests in this sequence** |
| `L{gameLevel}` | In-game level: `L-early` (tutorial), `L03` … `L30` |
| `N{grid}` | Grid size N×N when known (from parse or catalog) |
| `T{tier}` | Solver gate: minimum tier (1–4) before E2E solve must pass |

**Legacy names** (`EarlyGame.jpg`, `lvl3.jpg`, …) are retired — use seq-prefixed names only.

## Two axes of difficulty

1. **Pipeline (Phase 2)** — image parse difficulty: smaller N and easier levels first.
2. **Solver (Phase 4)** — algorithm tier: T1 → T2 → T3 → T4 per [solver_algorithms.md](../requirements/solver_algorithms.md).

Lower game level ≈ easier puzzle, but grid size N varies (e.g. L21 is 8×8, L15 is 10×10). **Seq order** balances both: tutorial and small grids first, large/hard grids later.

## Current catalog (seq 01–20)

| Seq | File | Game level | Grid N | Pipeline | Solver gate | Notes |
|-----|------|------------|--------|----------|-------------|-------|
| 01 | `01_L-early_N4_T1.jpg` | (tutorial) | 4 | ✅ Phase 2 golden | T1 | No on-screen level |
| 02 | `02_L03_N6_T1.jpg` | 3 | 6 | ✅ Phase 2 golden | T1 | First numbered level |
| 03 | `03_L04_T1.jpg` | 4 | — | Parse | T1 | |
| 04 | `04_L05_T1.jpg` | 5 | — | Parse | T1 | |
| 05 | `05_L06_T1.jpg` | 6 | — | Parse | T1 | |
| 06 | `06_L07_T1.jpg` | 7 | — | Parse | T1 | |
| 07 | `07_L08_T1.jpg` | 8 | — | Parse | T1 | |
| 08 | `08_L09_N9_T1.jpg` | 9 | 9 | Parse | T1 | Product N=9 target |
| 09 | `09_L10_N7_T2.jpg` | 10 | 7 | Parse | T2 | On-screen “Level 10” |
| 10 | `10_L11_T2.jpeg` | 11 | — | Parse | T2 | |
| 11 | `11_L12_T2.jpeg` | 12 | — | Parse | T2 | |
| 12 | `12_L13_T2.jpeg` | 13 | — | Parse | T2 | |
| 13 | `13_L14_T2.jpeg` | 14 | — | Parse | T2 | |
| 14 | `14_L15_N10_T3.jpeg` | 15 | 10 | Parse | T3 | No on-screen level; use filename |
| 15 | `15_L16_T3.jpeg` | 16 | — | Parse | T3 | |
| 16 | `16_L17_T3.jpeg` | 17 | — | Parse | T3 | |
| 17 | `17_L18_T3.jpeg` | 18 | — | Parse | T3 | |
| 18 | `18_L19_T4.jpeg` | 19 | — | Parse | T4 | |
| 19 | `19_L20_T4.jpeg` | 20 | — | Parse | T4 | |
| 20 | `20_L21_N8_T3.jpeg` | 21 | 8 | Parse | T3 | On-screen “Level 21” |

**Phase 2 golden minimum:** seq **01** + **02**. Expand seq upward before seq **14** (N=10).

**Phase 3 E2E target:** seq **08** (N=9).

**Phase 5 N>9 target:** seq **14** (N=10).

Solver gate tiers are **estimates** — update when a fixture is run against the live solver.

## Reserved (seq 21–30) — incoming batch

Add **after seq 19 (`L20`) solves end-to-end**. User will drop **10 screenshots** for in-app levels **21–30**.

| Seq | Expected game level | Solver gate | Status |
|-----|---------------------|-------------|--------|
| 21 | L21 | T4 | Reserved — may supersede seq 20 capture |
| 22 | L22 | T4 | Reserved |
| 23 | L23 | T4 | Reserved |
| 24 | L24 | T4 | Reserved |
| 25 | L25 | T4 | Reserved |
| 26 | L26 | T4 | Reserved |
| 27 | L27 | T4 | Reserved |
| 28 | L28 | T4 | Reserved |
| 29 | L29 | T4 | Reserved |
| 30 | L30 | T4 | Reserved |

When adding: `{seq:02d}_L{level}[_N{n}]_T{tier}.jpeg` — infer N from parse; confirm tier after first solve.

## Missing from app

`L01`, `L02` — not captured. Tutorial seq **01** (`L-early`) is pre-L03.
