use super::board::{Board, BLOCKED, CAT, EMPTY};
use super::tier1::apply_halo_enforcer;
use std::collections::HashSet;

/// Cells in the row, column, and Chebyshev-1 neighborhood of `(x, y)` (halo footprint).
fn halo_cells(x: usize, y: usize, size: usize) -> HashSet<(usize, usize)> {
    let mut cells = HashSet::new();

    for cx in 0..size {
        if cx != x {
            cells.insert((cx, y));
        }
    }

    for cy in 0..size {
        if cy != y {
            cells.insert((x, cy));
        }
    }

    for dy in -1i32..=1 {
        for dx in -1i32..=1 {
            if dx == 0 && dy == 0 {
                continue;
            }
            let nx = x as i32 + dx;
            let ny = y as i32 + dy;
            if nx < 0 || ny < 0 {
                continue;
            }
            let (nx, ny) = (nx as usize, ny as usize);
            if nx >= size || ny >= size {
                continue;
            }
            cells.insert((nx, ny));
        }
    }

    cells
}

fn empty_count_in_region(board: &Board, region_id: u8) -> usize {
    let size = board.size() as usize;
    let mut count = 0usize;
    for y in 0..size {
        for x in 0..size {
            if board.region_at(x, y) == region_id && board.get(x, y) == EMPTY {
                count += 1;
            }
        }
    }
    count
}

fn causes_mutual_destruction(board: &Board, region_a: u8, x: usize, y: usize) -> bool {
    let mut sim = board.clone();
    sim.set(x, y, CAT);
    apply_halo_enforcer(&mut sim);

    let size = board.size() as usize;
    let halo = halo_cells(x, y, size);
    let mut adjacent_regions = HashSet::new();
    for (hx, hy) in halo {
        let region_b = board.region_at(hx, hy);
        if region_b != region_a {
            adjacent_regions.insert(region_b);
        }
    }

    for region_b in adjacent_regions {
        if empty_count_in_region(&sim, region_b) == 0 {
            return true;
        }
    }

    false
}

/// Region-to-Region Crowding — block empties whose cat placement would wipe an adjacent region.
pub fn apply_region_crowding(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let max_region = board.regions.iter().copied().max().unwrap_or(0);
    let mut changed = false;

    for region_id in 1..=max_region {
        for y in 0..size {
            for x in 0..size {
                if board.region_at(x, y) != region_id || board.get(x, y) != EMPTY {
                    continue;
                }
                if causes_mutual_destruction(board, region_id, x, y) {
                    board.set(x, y, BLOCKED);
                    changed = true;
                }
            }
        }
    }

    changed
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::board::Board;
    use crate::solver::test_helpers::idx;
    use crate::solver::tier4_phantom::apply_phantom_projection;

    fn crowding_trap_board() -> Board {
        let size = 6u32;
        let n = size as usize;
        // Region 1 = background + candidate row; region 2 = single empty above the trap cell.
        let regions = vec![1u8; n * n];
        let mut regions = regions;
        regions[idx(3, 1, n)] = 2;

        let mut state = vec![BLOCKED; n * n];
        for x in 2..=5 {
            state[idx(x, 2, n)] = EMPTY;
        }
        state[idx(3, 1, n)] = EMPTY;

        Board::new(state, regions, size)
    }

    #[test]
    fn crowding_blocks_empty_that_would_destroy_adjacent_region() {
        let mut board = crowding_trap_board();
        assert!(apply_region_crowding(&mut board));
        // (5,2) is the only region-1 empty whose halo does not wipe region 2.
        assert_eq!(board.get(5, 2), EMPTY);
        assert_eq!(board.get(3, 2), BLOCKED);
        assert_eq!(board.get(4, 2), BLOCKED);
        assert_eq!(board.get(2, 2), BLOCKED);
        assert_eq!(board.get(3, 1), EMPTY);
    }

    #[test]
    fn crowding_skips_when_no_adjacent_region_in_halo() {
        let size = 3u32;
        let n = size as usize;
        let regions = vec![1u8; n * n];
        let mut state = vec![BLOCKED; n * n];
        state[idx(1, 1, n)] = EMPTY;

        let mut board = Board::new(state, regions, size);
        assert!(!apply_region_crowding(&mut board));
        assert_eq!(board.get(1, 1), EMPTY);
    }

    #[test]
    fn crowding_deduces_when_phantom_stalls() {
        let mut board = crowding_trap_board();
        assert!(!apply_phantom_projection(&mut board));
        assert!(apply_region_crowding(&mut board));
        assert_eq!(board.get(3, 2), BLOCKED);
    }
}
