# Board screenshot fixtures

Repo root: `assets/test_fixtures/`

## Difficulty rule

**Game level number = difficulty.** Filename `lvl{N}` matches in-game “Level N” on most screenshots. **Work and test easy levels first** — lower `N` = easier puzzle.

- **`EarlyGame.jpg`** — no level in filename or screenshot; **4×4 tutorial** → treat as **before `lvl3`**
- **`lvl15.jpeg`** — no on-screen level header; use filename → level **15** (10×10 grid)
- **Missing:** `lvl1`, `lvl2` not in folder

## Work order

| Order | File | Level | On-screen level | Grid | Notes |
|-------|------|-------|-----------------|------|-------|
| 1 | `EarlyGame.jpg` | — | None | ~4×4 | Tutorial; easiest |
| 2 | `lvl3.jpg` | 3 | Level 3 | 6×6 | First numbered level |
| 3 | `lvl4.jpg` | 4 | — | — | |
| 4 | `lvl5.jpg` | 5 | — | — | |
| 5 | `lvl6.jpg` | 6 | — | — | |
| 6 | `lvl7.jpg` | 7 | — | — | |
| 7 | `lvl8.jpg` | 8 | — | — | |
| 8 | `lvl9.jpg` | 9 | — | — | Product N=9 target |
| 9 | `lvl10.jpg` | 10 | Level 10 | 7×7 | |
| 10 | `lvl11.jpeg` | 11 | — | — | |
| 11 | `lvl12.jpeg` | 12 | — | — | |
| 12 | `lvl13.jpeg` | 13 | — | — | |
| 13 | `lvl14.jpeg` | 14 | — | — | |
| 14 | `lvl15.jpeg` | 15 | None | 10×10 | Filename level |
| 15 | `lvl16.jpeg` | 16 | — | — | |
| 16 | `lvl17.jpeg` | 17 | — | — | |
| 17 | `lvl18.jpeg` | 18 | — | — | |
| 18 | `lvl19.jpeg` | 19 | — | — | |
| 19 | `lvl20.jpeg` | 20 | — | — | |
| 20 | `lvl21.jpeg` | 21 | Level 21 | 8×8 | Highest in set |

**Phase 2 golden minimum:** `EarlyGame` + `lvl3`. Expand upward before tackling `lvl15` (10×10).
