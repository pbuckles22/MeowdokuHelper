use crate::solver::board::{Board, CAT};
use crate::solver::tier4::run_tiers_1_through_6;

/// Returns cell index 0..(N²-1) for the next forced cat placement (Tiers 1–6), or -1.
#[flutter_rust_bridge::frb(sync)]
pub fn calculate_next_move(state: Vec<u8>, regions: Vec<u8>, grid_size: u32) -> i32 {
    let expected = (grid_size * grid_size) as usize;
    if state.len() != expected || regions.len() != expected {
        return -1;
    }

    let before = state.clone();
    let mut board = Board::new(state, regions, grid_size);
    run_tiers_1_through_6(&mut board);

    for i in 0..expected {
        if before[i] != CAT && board.state[i] == CAT {
            return i as i32;
        }
    }

    -1
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::board::{BLOCKED, CAT, EMPTY};
    use crate::solver::test_helpers::{checkerboard_regions, quadrant_regions};

    #[test]
    fn returns_choke_point_index_at_nine() {
        let size = 9u32;
        let choke_x = 2usize;
        let choke_y = 8usize;
        let mut state = vec![BLOCKED; 81];
        state[choke_y * 9 + choke_x] = EMPTY;
        state[4 * 9 + 4] = CAT;

        let regions = checkerboard_regions(size);
        let idx = calculate_next_move(state, regions, size);
        assert_eq!(idx, (choke_y * 9 + choke_x) as i32);
    }

    #[test]
    fn returns_minus_one_for_invalid_lengths() {
        assert_eq!(calculate_next_move(vec![0], vec![0, 0], 9), -1);
    }

    #[test]
    fn returns_minus_one_when_truly_stuck() {
        let size = 9u32;
        let state = vec![BLOCKED; 81];
        let regions = checkerboard_regions(size);
        assert_eq!(calculate_next_move(state, regions, size), -1);
    }

    #[test]
    fn seq01_phase2_golden_returns_forced_move() {
        let state = vec![
            0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        ];
        let regions = vec![
            2, 1, 3, 1, 2, 1, 1, 1, 2, 2, 3, 1, 2, 3, 3, 1,
        ];
        assert_eq!(calculate_next_move(state, regions, 4), 4);
    }

    #[test]
    fn seq02_phase2_golden_returns_forced_move() {
        let state = vec![
            0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        ];
        let regions = vec![
            2, 2, 2, 2, 2, 3, 2, 1, 6, 2, 2, 2, 5, 1, 1, 1, 1, 2, 1, 1, 3, 3, 2, 2,
            1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 4, 3,
        ];
        assert_eq!(calculate_next_move(state, regions, 6), 8);
    }

    #[test]
    fn tier2_intersection_board_returns_forced_index() {
        let size = 4u32;
        let n = size as usize;
        let regions = quadrant_regions(size);

        let mut state = vec![BLOCKED; n * n];
        state[0] = EMPTY;
        state[1] = EMPTY;
        state[4] = EMPTY;
        state[5] = EMPTY;

        assert_eq!(calculate_next_move(state, regions, size), 0);
    }
}
