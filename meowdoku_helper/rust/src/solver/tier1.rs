use super::board::{Board, BLOCKED, CAT, EMPTY};

/// Block empty cells in the row, column, and 8-neighbor halo of each cat.
pub fn apply_halo_enforcer(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let mut changed = false;

    for y in 0..size {
        for x in 0..size {
            if board.get(x, y) != CAT {
                continue;
            }

            for cx in 0..size {
                if board.get(cx, y) == EMPTY {
                    board.set(cx, y, BLOCKED);
                    changed = true;
                }
            }

            for cy in 0..size {
                if board.get(x, cy) == EMPTY {
                    board.set(x, cy, BLOCKED);
                    changed = true;
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
                    if board.get(nx, ny) == EMPTY {
                        board.set(nx, ny, BLOCKED);
                        changed = true;
                    }
                }
            }
        }
    }

    changed
}

/// Place a cat when a row, column, or region has exactly one empty and zero cats.
pub fn apply_naked_singles(board: &mut Board) -> bool {
    let size = board.size() as usize;
    let mut changed = false;

    for y in 0..size {
        let mut empty_count = 0usize;
        let mut empty_x = 0usize;
        let mut cat_count = 0usize;

        for x in 0..size {
            match board.get(x, y) {
                EMPTY => {
                    empty_count += 1;
                    empty_x = x;
                }
                CAT => cat_count += 1,
                _ => {}
            }
        }

        if empty_count == 1 && cat_count == 0 {
            board.set(empty_x, y, CAT);
            changed = true;
        }
    }

    for x in 0..size {
        let mut empty_count = 0usize;
        let mut empty_y = 0usize;
        let mut cat_count = 0usize;

        for y in 0..size {
            match board.get(x, y) {
                EMPTY => {
                    empty_count += 1;
                    empty_y = y;
                }
                CAT => cat_count += 1,
                _ => {}
            }
        }

        if empty_count == 1 && cat_count == 0 {
            board.set(x, empty_y, CAT);
            changed = true;
        }
    }

    let max_region = board.regions.iter().copied().max().unwrap_or(0);
    for region_id in 1..=max_region {
        let mut empty_count = 0usize;
        let mut empty_pos = (0usize, 0usize);
        let mut cat_count = 0usize;

        for y in 0..size {
            for x in 0..size {
                if board.region_at(x, y) != region_id {
                    continue;
                }
                match board.get(x, y) {
                    EMPTY => {
                        empty_count += 1;
                        empty_pos = (x, y);
                    }
                    CAT => cat_count += 1,
                    _ => {}
                }
            }
        }

        if empty_count == 1 && cat_count == 0 {
            board.set(empty_pos.0, empty_pos.1, CAT);
            changed = true;
        }
    }

    changed
}

/// Run Tier 1 until no state changes. Returns true if the board was modified.
pub fn run_tier1(board: &mut Board) -> bool {
    let mut any_change = false;

    loop {
        let halo_changed = apply_halo_enforcer(board);
        let singles_changed = apply_naked_singles(board);

        if halo_changed || singles_changed {
            any_change = true;
        } else {
            break;
        }
    }

    any_change
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::board::Board;
    use crate::solver::test_helpers::checkerboard_regions;

    fn empty_board(size: u32) -> Board {
        let len = (size * size) as usize;
        Board::new(vec![EMPTY; len], checkerboard_regions(size), size)
    }

    #[test]
    fn halo_enforcer_blocks_row_col_and_neighbors() {
        let mut board = empty_board(9);
        board.set(4, 4, CAT);

        assert!(apply_halo_enforcer(&mut board));

        for x in 0..9 {
            if x != 4 {
                assert_eq!(board.get(x, 4), BLOCKED, "row halo at ({x}, 4)");
                assert_eq!(board.get(4, x), BLOCKED, "col halo at (4, {x})");
            }
        }

        assert_eq!(board.get(3, 3), BLOCKED);
        assert_eq!(board.get(5, 5), BLOCKED);
        assert_eq!(board.get(4, 4), CAT);
    }

    #[test]
    fn naked_single_places_cat_in_row_choke_point() {
        let size = 9u32;
        let choke_x = 4usize;
        let choke_y = 5usize;
        let mut state = vec![BLOCKED; 81];
        state[choke_y * 9 + choke_x] = EMPTY;

        let mut board = Board::new(state, checkerboard_regions(size), size);
        assert!(apply_naked_singles(&mut board));
        assert_eq!(board.get(choke_x, choke_y), CAT);
    }

    #[test]
    fn tier1_run_places_cat_at_row_choke_point() {
        let size = 9u32;
        let choke_x = 2usize;
        let choke_y = 8usize;
        let mut state = vec![BLOCKED; 81];
        state[choke_y * 9 + choke_x] = EMPTY;
        state[4 * 9 + 4] = CAT;

        let mut board = Board::new(state, checkerboard_regions(size), size);
        assert!(run_tier1(&mut board));
        assert_eq!(board.get(choke_x, choke_y), CAT);
    }
}
