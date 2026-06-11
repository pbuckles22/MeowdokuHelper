use super::board::{Board, BLOCKED, CAT, EMPTY};
use std::collections::HashSet;

/// Cells affected by the standard 8-neighbor halo (row, column, Chebyshev-1) of `(x, y)`.
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

/// Phantom Cat Projection — block empties in the overlap of candidate halos (regions with 2–3 empties).
pub fn apply_phantom_projection(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let max_region = board.regions.iter().copied().max().unwrap_or(0);
    let mut changed = false;

    for region_id in 1..=max_region {
        let mut empties = Vec::new();
        let mut cat_count = 0usize;

        for y in 0..size {
            for x in 0..size {
                if board.region_at(x, y) != region_id {
                    continue;
                }
                match board.get(x, y) {
                    EMPTY => empties.push((x, y)),
                    CAT => cat_count += 1,
                    _ => {}
                }
            }
        }

        if cat_count > 0 || empties.len() < 2 || empties.len() > 3 {
            continue;
        }

        let mut intersection = halo_cells(empties[0].0, empties[0].1, size);
        for &(x, y) in &empties[1..] {
            intersection = intersection
                .intersection(&halo_cells(x, y, size))
                .copied()
                .collect();
        }

        for (x, y) in intersection {
            if board.get(x, y) == EMPTY {
                board.set(x, y, BLOCKED);
                changed = true;
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

    #[test]
    fn phantom_blocks_halo_intersection_for_two_candidate_empties() {
        let size = 5u32;
        let n = size as usize;
        let mut regions = vec![2u8; n * n];
        regions[idx(1, 1, n)] = 1;
        regions[idx(2, 1, n)] = 1;
        regions[idx(1, 2, n)] = 2;

        let mut state = vec![BLOCKED; n * n];
        state[idx(1, 1, n)] = EMPTY;
        state[idx(2, 1, n)] = EMPTY;
        state[idx(1, 2, n)] = EMPTY;

        let mut board = Board::new(state, regions, size);
        assert!(apply_phantom_projection(&mut board));
        assert_eq!(board.get(1, 2), BLOCKED);
        assert_eq!(board.get(1, 1), EMPTY);
        assert_eq!(board.get(2, 1), EMPTY);
    }

    #[test]
    fn phantom_blocks_intersection_for_three_candidate_empties_in_row() {
        let size = 5u32;
        let n = size as usize;
        let mut regions = vec![2u8; n * n];
        for x in 1..=3 {
            regions[idx(x, 1, n)] = 1;
        }
        regions[idx(2, 2, n)] = 2;

        let mut state = vec![BLOCKED; n * n];
        state[idx(1, 1, n)] = EMPTY;
        state[idx(2, 1, n)] = EMPTY;
        state[idx(3, 1, n)] = EMPTY;
        state[idx(2, 2, n)] = EMPTY;

        let mut board = Board::new(state, regions, size);
        assert!(apply_phantom_projection(&mut board));
        assert_eq!(board.get(2, 2), BLOCKED);
    }

    #[test]
    fn phantom_skips_region_with_cat_or_wrong_empty_count() {
        let size = 4u32;
        let n = size as usize;
        let mut regions = vec![2u8; n * n];
        regions[idx(0, 0, n)] = 1;
        regions[idx(1, 0, n)] = 1;

        let mut state = vec![BLOCKED; n * n];
        state[idx(0, 0, n)] = CAT;
        state[idx(1, 0, n)] = EMPTY;

        let mut board = Board::new(state, regions, size);
        assert!(!apply_phantom_projection(&mut board));
    }
}
