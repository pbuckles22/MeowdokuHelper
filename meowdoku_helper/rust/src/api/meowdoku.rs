use crate::solver::board::{Board, CAT};
use crate::solver::tier4::run_tiers_1_through_4;

/// Returns cell index 0..(N²-1) for the next forced cat placement (Tiers 1–4), or -1.
#[flutter_rust_bridge::frb(sync)]
pub fn calculate_next_move(state: Vec<u8>, regions: Vec<u8>, grid_size: u32) -> i32 {
    let expected = (grid_size * grid_size) as usize;
    if state.len() != expected || regions.len() != expected {
        return -1;
    }

    let before = state.clone();
    let mut board = Board::new(state, regions, grid_size);
    run_tiers_1_through_4(&mut board);

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

    fn checkerboard_regions(size: u32) -> Vec<u8> {
        let n = size as usize;
        (0..n * n)
            .map(|idx| {
                let (x, y) = (idx % n, idx / n);
                (((x + y) % n) + 1) as u8
            })
            .collect()
    }

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
    fn tier2_intersection_board_returns_forced_index() {
        let size = 4u32;
        let n = size as usize;
        let half = n / 2;
        let regions: Vec<u8> = (0..n * n)
            .map(|idx| {
                let (x, y) = (idx % n, idx / n);
                let qx = if x < half { 0 } else { 1 };
                let qy = if y < half { 0 } else { 1 };
                (qy * 2 + qx + 1) as u8
            })
            .collect();

        let mut state = vec![BLOCKED; n * n];
        state[0] = EMPTY;
        state[1] = EMPTY;
        state[4] = EMPTY;
        state[5] = EMPTY;

        assert_eq!(calculate_next_move(state, regions, size), 0);
    }
}
