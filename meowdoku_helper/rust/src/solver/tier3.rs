use super::board::{Board, BLOCKED, EMPTY};
use super::tier2::run_tiers_1_and_2;
use std::collections::HashSet;

/// Region empties fit in one 2×2 → at most one cat in that block; block other regions' empties there.
pub fn apply_trap_2x2(board: &mut Board) -> bool {
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

        let min_x = empties.iter().map(|(x, _)| *x).min().unwrap();
        let max_x = empties.iter().map(|(x, _)| *x).max().unwrap();
        let min_y = empties.iter().map(|(_, y)| *y).min().unwrap();
        let max_y = empties.iter().map(|(_, y)| *y).max().unwrap();

        if max_x - min_x > 1 || max_y - min_y > 1 {
            continue;
        }

        for dy in 0..=1 {
            for dx in 0..=1 {
                let x = min_x + dx;
                let y = min_y + dy;
                if x >= size || y >= size {
                    continue;
                }
                if board.get(x, y) == EMPTY && board.region_at(x, y) != region_id {
                    board.set(x, y, BLOCKED);
                    changed = true;
                }
            }
        }
    }

    changed
}

fn apply_locked_columns(board: &mut Board, cols: &[usize]) -> bool {
    let size = board.size() as usize;
    let mut regions = HashSet::new();
    for &x in cols {
        for y in 0..size {
            if board.get(x, y) == EMPTY {
                regions.insert(board.region_at(x, y));
            }
        }
    }
    if regions.len() != cols.len() {
        return false;
    }

    let col_set: HashSet<usize> = cols.iter().copied().collect();
    let mut changed = false;
    for &region_id in &regions {
        for y in 0..size {
            for x in 0..size {
                if !col_set.contains(&x)
                    && board.region_at(x, y) == region_id
                    && board.get(x, y) == EMPTY
                {
                    board.set(x, y, BLOCKED);
                    changed = true;
                }
            }
        }
    }
    changed
}

fn apply_locked_rows(board: &mut Board, rows: &[usize]) -> bool {
    let size = board.size() as usize;
    let mut regions = HashSet::new();
    for &y in rows {
        for x in 0..size {
            if board.get(x, y) == EMPTY {
                regions.insert(board.region_at(x, y));
            }
        }
    }
    if regions.len() != rows.len() {
        return false;
    }

    let row_set: HashSet<usize> = rows.iter().copied().collect();
    let mut changed = false;
    for &region_id in &regions {
        for y in 0..size {
            for x in 0..size {
                if !row_set.contains(&y)
                    && board.region_at(x, y) == region_id
                    && board.get(x, y) == EMPTY
                {
                    board.set(x, y, BLOCKED);
                    changed = true;
                }
            }
        }
    }
    changed
}

/// N columns/rows whose empties span exactly N regions → block those regions outside the lines.
///
/// Uses **consecutive** column/row windows of width 2–4 only (not arbitrary subsets).
/// Sufficient for shipped fixtures; may miss exotic locked-set patterns on harder boards.
pub fn apply_locked_sets(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let mut changed = false;

    for n in 2..=size.min(4) {
        for c0 in 0..size {
            changed |= apply_locked_column_window(board, c0, n);
        }
        for r0 in 0..size {
            changed |= apply_locked_row_window(board, r0, n);
        }
    }

    changed
}

fn apply_locked_column_window(board: &mut Board, start: usize, n: usize) -> bool {
    let size = board.size() as usize;
    if start + n > size {
        return false;
    }
    let cols: Vec<usize> = (start..start + n).collect();
    apply_locked_columns(board, &cols)
}

fn apply_locked_row_window(board: &mut Board, start: usize, n: usize) -> bool {
    let size = board.size() as usize;
    if start + n > size {
        return false;
    }
    let rows: Vec<usize> = (start..start + n).collect();
    apply_locked_rows(board, &rows)
}

/// Run Tiers 1–3 until all stall. Tier 3 blocks restart at lower tiers.
pub fn run_tiers_1_through_3(board: &mut Board) -> bool {
    let mut any = false;
    loop {
        if run_tiers_1_and_2(board) {
            any = true;
        }
        let tier3_changed = apply_trap_2x2(board) || apply_locked_sets(board);
        if tier3_changed {
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
    use crate::solver::board::{Board, BLOCKED, EMPTY};
    use crate::solver::test_helpers::idx;

    fn split_2x2_regions(size: u32) -> Vec<u8> {
        let n = size as usize;
        let mut regions = vec![3u8; n * n];
        regions[idx(0, 0, n)] = 1;
        regions[idx(1, 0, n)] = 1;
        regions[idx(0, 1, n)] = 1;
        regions[idx(1, 1, n)] = 2;
        regions
    }

    #[test]
    fn trap_2x2_blocks_other_region_in_shared_block() {
        let size = 4u32;
        let n = size as usize;
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = EMPTY;
        state[idx(1, 0, n)] = EMPTY;
        state[idx(0, 1, n)] = EMPTY;
        state[idx(1, 1, n)] = EMPTY;

        let mut board = Board::new(state, split_2x2_regions(size), size);
        assert!(apply_trap_2x2(&mut board));
        assert_eq!(board.get(1, 1), BLOCKED);
        assert_eq!(board.get(0, 0), EMPTY);
    }

    #[test]
    fn locked_sets_blocks_locked_region_outside_column_pair() {
        let size = 4u32;
        let n = size as usize;
        let mut regions = split_2x2_regions(size);
        regions[idx(2, 2, n)] = 1;
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = EMPTY;
        state[idx(1, 0, n)] = EMPTY;
        state[idx(0, 1, n)] = EMPTY;
        state[idx(1, 1, n)] = EMPTY;
        state[idx(2, 2, n)] = EMPTY;

        let mut board = Board::new(state, regions, size);
        assert!(apply_locked_sets(&mut board));
        assert_eq!(board.get(2, 2), BLOCKED);
    }

    #[test]
    fn tier3_trap_board_returns_forced_cat_via_calculate_next_move() {
        let size = 4u32;
        let n = size as usize;
        let mut regions = split_2x2_regions(size);
        regions[idx(1, 0, n)] = 2;
        regions[idx(0, 1, n)] = 2;
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = EMPTY;
        state[idx(1, 0, n)] = EMPTY;
        state[idx(0, 1, n)] = EMPTY;
        state[idx(1, 1, n)] = EMPTY;

        let idx = crate::api::meowdoku::propagate_next_move_index(state, regions, size);
        assert!(idx >= 0);
    }
}
