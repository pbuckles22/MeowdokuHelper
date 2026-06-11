use super::board::{Board, BLOCKED, EMPTY};
use super::tier1::run_tier1;

/// All empties in a region lie on one row/column → block other empties on that line outside the region.
pub fn apply_region_claims_line(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let max_region = board.regions.iter().copied().max().unwrap_or(0);
    let mut changed = false;

    for region_id in 1..=max_region {
        let mut empties = Vec::new();
        for y in 0..size {
            for x in 0..size {
                if board.region_at(x, y) == region_id && board.get(x, y) == EMPTY {
                    empties.push((x, y));
                }
            }
        }
        if empties.is_empty() {
            continue;
        }

        let rows: std::collections::HashSet<usize> = empties.iter().map(|(_, y)| *y).collect();
        let cols: std::collections::HashSet<usize> = empties.iter().map(|(x, _)| *x).collect();

        if rows.len() == 1 {
            let row = *rows.iter().next().unwrap();
            for x in 0..size {
                if board.region_at(x, row) != region_id && board.get(x, row) == EMPTY {
                    board.set(x, row, BLOCKED);
                    changed = true;
                }
            }
        }

        if cols.len() == 1 {
            let col = *cols.iter().next().unwrap();
            for y in 0..size {
                if board.region_at(col, y) != region_id && board.get(col, y) == EMPTY {
                    board.set(col, y, BLOCKED);
                    changed = true;
                }
            }
        }
    }

    changed
}

/// Row/column empties all belong to one region → block that region's empties outside the line.
pub fn apply_line_claims_region(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let mut changed = false;

    for y in 0..size {
        let region_ids: std::collections::HashSet<u8> = (0..size)
            .filter(|&x| board.get(x, y) == EMPTY)
            .map(|x| board.region_at(x, y))
            .collect();
        if region_ids.len() != 1 {
            continue;
        }
        let region_id = *region_ids.iter().next().unwrap();
        for cy in 0..size {
            for cx in 0..size {
                if board.region_at(cx, cy) == region_id
                    && cy != y
                    && board.get(cx, cy) == EMPTY
                {
                    board.set(cx, cy, BLOCKED);
                    changed = true;
                }
            }
        }
    }

    for x in 0..size {
        let region_ids: std::collections::HashSet<u8> = (0..size)
            .filter(|&y| board.get(x, y) == EMPTY)
            .map(|y| board.region_at(x, y))
            .collect();
        if region_ids.len() != 1 {
            continue;
        }
        let region_id = *region_ids.iter().next().unwrap();
        for cy in 0..size {
            for cx in 0..size {
                if board.region_at(cx, cy) == region_id
                    && cx != x
                    && board.get(cx, cy) == EMPTY
                {
                    board.set(cx, cy, BLOCKED);
                    changed = true;
                }
            }
        }
    }

    changed
}

/// Run Tier 1 and Tier 2 until both stall. Tier 2 blocks restart at Tier 1.
pub fn run_tiers_1_and_2(board: &mut Board) -> bool {
    let mut any = false;
    loop {
        if run_tier1(board) {
            any = true;
        }
        let tier2_changed = apply_region_claims_line(board) || apply_line_claims_region(board);
        if tier2_changed {
            any = true;
            continue;
        }
        break;
    }
    any
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::board::{Board, BLOCKED, CAT, EMPTY};

    fn quadrant_regions(size: u32) -> Vec<u8> {
        let n = size as usize;
        let half = n / 2;
        (0..n * n)
            .map(|idx| {
                let (x, y) = (idx % n, idx / n);
                let qx = if x < half { 0 } else { 1 };
                let qy = if y < half { 0 } else { 1 };
                (qy * 2 + qx + 1) as u8
            })
            .collect()
    }

    fn idx(x: usize, y: usize, n: usize) -> usize {
        y * n + x
    }

    #[test]
    fn region_claims_line_blocks_outside_empties_on_shared_row() {
        let size = 4u32;
        let n = size as usize;
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = EMPTY;
        state[idx(1, 0, n)] = EMPTY;
        state[idx(2, 0, n)] = EMPTY;

        let mut board = Board::new(state, quadrant_regions(size), size);
        assert!(apply_region_claims_line(&mut board));
        assert_eq!(board.get(2, 0), BLOCKED);
        assert_eq!(board.get(0, 0), EMPTY);
        assert_eq!(board.get(1, 0), EMPTY);
    }

    #[test]
    fn line_claims_region_blocks_region_empties_off_line() {
        let size = 4u32;
        let n = size as usize;
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = EMPTY;
        state[idx(0, 1, n)] = EMPTY;

        let mut board = Board::new(state, quadrant_regions(size), size);
        assert!(apply_line_claims_region(&mut board));
        assert_eq!(board.get(0, 0), EMPTY);
        assert_eq!(board.get(0, 1), BLOCKED);
    }

    #[test]
    fn tier1_stalls_then_tier2_enables_naked_single() {
        let size = 4u32;
        let n = size as usize;
        let regions = quadrant_regions(size);
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = EMPTY;
        state[idx(1, 0, n)] = EMPTY;
        state[idx(0, 1, n)] = EMPTY;
        state[idx(1, 1, n)] = EMPTY;

        let mut tier1_only = Board::new(state.clone(), regions.clone(), size);
        assert!(!run_tier1(&mut tier1_only));
        assert_eq!(tier1_only.get(0, 0), EMPTY);

        let mut board = Board::new(state, regions, size);
        assert!(run_tiers_1_and_2(&mut board));
        assert_eq!(board.get(0, 0), CAT);
    }
}
