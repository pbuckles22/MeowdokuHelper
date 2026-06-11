use super::board::{Board, BLOCKED, CAT, EMPTY};
use super::tier3::run_tiers_1_through_3;

/// Row/col/region with zero cats and zero empties can never be satisfied.
pub fn is_illegal(board: &Board) -> bool {
    let size = board.size() as usize;

    for y in 0..size {
        let (cats, empties) = row_counts(board, y);
        if cats > 1 || (cats == 0 && empties == 0) {
            return true;
        }
    }

    for x in 0..size {
        let (cats, empties) = col_counts(board, x);
        if cats > 1 || (cats == 0 && empties == 0) {
            return true;
        }
    }

    let max_region = board.regions.iter().copied().max().unwrap_or(0);
    for region_id in 1..=max_region {
        let (cats, empties) = region_counts(board, region_id);
        if cats > 1 || (cats == 0 && empties == 0) {
            return true;
        }
    }

    false
}

/// Solved when every row, column, and region has exactly one cat.
pub fn is_solved(board: &Board) -> bool {
    let size = board.size() as usize;

    for y in 0..size {
        if row_counts(board, y).0 != 1 {
            return false;
        }
    }

    for x in 0..size {
        if col_counts(board, x).0 != 1 {
            return false;
        }
    }

    let max_region = board.regions.iter().copied().max().unwrap_or(0);
    for region_id in 1..=max_region {
        if region_counts(board, region_id).0 != 1 {
            return false;
        }
    }

    true
}

fn row_counts(board: &Board, y: usize) -> (usize, usize) {
    let size = board.size() as usize;
    let mut cats = 0usize;
    let mut empties = 0usize;
    for x in 0..size {
        match board.get(x, y) {
            CAT => cats += 1,
            EMPTY => empties += 1,
            _ => {}
        }
    }
    (cats, empties)
}

fn col_counts(board: &Board, x: usize) -> (usize, usize) {
    let size = board.size() as usize;
    let mut cats = 0usize;
    let mut empties = 0usize;
    for y in 0..size {
        match board.get(x, y) {
            CAT => cats += 1,
            EMPTY => empties += 1,
            _ => {}
        }
    }
    (cats, empties)
}

fn region_counts(board: &Board, region_id: u8) -> (usize, usize) {
    let size = board.size() as usize;
    let mut cats = 0usize;
    let mut empties = 0usize;
    for y in 0..size {
        for x in 0..size {
            if board.region_at(x, y) != region_id {
                continue;
            }
            match board.get(x, y) {
                CAT => cats += 1,
                EMPTY => empties += 1,
                _ => {}
            }
        }
    }
    (cats, empties)
}

fn first_empty(board: &Board) -> Option<(usize, usize)> {
    let size = board.size() as usize;
    for y in 0..size {
        for x in 0..size {
            if board.get(x, y) == EMPTY {
                return Some((x, y));
            }
        }
    }
    None
}

/// Recursively guess on a trial board until solved or exhausted.
fn dfs_solve(board: &mut Board) -> bool {
    loop {
        run_tiers_1_through_3(board);

        if is_illegal(board) {
            return false;
        }
        if is_solved(board) {
            return true;
        }

        let Some((x, y)) = first_empty(board) else {
            return false;
        };

        let mut trial = board.clone();
        trial.set(x, y, CAT);
        run_tiers_1_through_3(&mut trial);

        if is_illegal(&trial) {
            board.set(x, y, BLOCKED);
            continue;
        }
        if is_solved(&trial) {
            board.set(x, y, CAT);
            return true;
        }
        if dfs_solve(&mut trial) {
            board.set(x, y, CAT);
            return true;
        }
        board.set(x, y, BLOCKED);
    }
}

/// One bifurcation step when Tiers 1–3 stall: try cat at first empty, recurse via [dfs_solve], or block.
pub fn dfs_bifurcation(board: &mut Board) -> bool {
    let Some((x, y)) = first_empty(board) else {
        return false;
    };

    let mut trial = board.clone();
    trial.set(x, y, CAT);
    run_tiers_1_through_3(&mut trial);

    if is_illegal(&trial) {
        board.set(x, y, BLOCKED);
        return true;
    }
    if is_solved(&trial) {
        board.set(x, y, CAT);
        return true;
    }
    if dfs_solve(&mut trial) {
        board.set(x, y, CAT);
        return true;
    }

    board.set(x, y, BLOCKED);
    true
}

/// Run Tiers 1–4 until all stall. Tier 4 blocks restart at lower tiers.
pub fn run_tiers_1_through_4(board: &mut Board) -> bool {
    let mut any = false;
    loop {
        if run_tiers_1_through_3(board) {
            any = true;
        }
        if !dfs_bifurcation(board) {
            break;
        }
        any = true;
    }
    any
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::board::Board;
    use crate::solver::test_helpers::{idx, quadrant_regions};

    #[test]
    fn illegal_when_row_has_no_cats_and_no_empties() {
        let size = 4u32;
        let n = size as usize;
        let state = vec![BLOCKED; n * n];
        let board = Board::new(state, quadrant_regions(size), size);
        assert!(is_illegal(&board));
    }

    #[test]
    fn solved_when_each_line_and_region_has_one_cat() {
        let size = 4u32;
        let n = size as usize;
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = CAT;
        state[idx(2, 1, n)] = CAT;
        state[idx(1, 2, n)] = CAT;
        state[idx(3, 3, n)] = CAT;
        let board = Board::new(state, quadrant_regions(size), size);
        assert!(is_solved(&board));
    }

    /// 4×4 partial: two empties in row 3; (2,3) over-fills col 2, (3,3) completes the grid.
    #[test]
    fn dfs_finds_cat_when_tiers_stall() {
        let size = 4u32;
        let n = size as usize;
        let regions = quadrant_regions(size);
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = CAT;
        state[idx(2, 1, n)] = CAT;
        state[idx(1, 2, n)] = CAT;
        state[idx(2, 3, n)] = EMPTY;
        state[idx(3, 3, n)] = EMPTY;

        let mut board = Board::new(state, regions, size);
        assert!(dfs_bifurcation(&mut board));
        assert_eq!(board.get(2, 3), BLOCKED);
        assert!(dfs_bifurcation(&mut board));
        assert_eq!(board.get(3, 3), CAT);
    }

    #[test]
    fn tier4_board_returns_forced_cat_via_calculate_next_move() {
        let size = 4u32;
        let n = size as usize;
        let regions = quadrant_regions(size);
        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = CAT;
        state[idx(2, 1, n)] = CAT;
        state[idx(1, 2, n)] = CAT;
        state[idx(2, 3, n)] = EMPTY;
        state[idx(3, 3, n)] = EMPTY;

        let move_idx = crate::api::meowdoku::calculate_next_move(state, regions, size);
        assert_eq!(move_idx, idx(3, 3, n) as i32);
    }
}
