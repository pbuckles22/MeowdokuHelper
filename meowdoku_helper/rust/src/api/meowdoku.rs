use crate::solver::board::{Board, CAT, BLOCKED, EMPTY};
use crate::solver::tier4::{run_tiers_1_through_5, run_tiers_1_through_6};

/// Solver needs Tier 6 branching — not a deterministic hint (US-7.2).
pub const BRANCH_REQUIRED: i32 = -2;

/// Classify solver output: forced index, branch required, or stuck.
pub(crate) fn classify_solver_step(before: &[u8], after_t5: &[u8], after_t6: &[u8]) -> i32 {
    for i in 0..before.len() {
        if before[i] != CAT && after_t5[i] == CAT {
            return i as i32;
        }
    }
    for i in 0..before.len() {
        if before[i] != CAT && after_t6[i] == CAT {
            return BRANCH_REQUIRED;
        }
    }
    -1
}

/// Tier propagation only — no uniqueness filter (QA block-test uses this).
pub(crate) fn propagate_next_move_index(
    state: Vec<u8>,
    regions: Vec<u8>,
    grid_size: u32,
) -> i32 {
    let expected = (grid_size * grid_size) as usize;
    if state.len() != expected || regions.len() != expected {
        return -1;
    }

    let before = state.clone();
    let regions_clone = regions.clone();

    let mut deterministic = Board::new(state.clone(), regions.clone(), grid_size);
    run_tiers_1_through_5(&mut deterministic);

    let mut with_branch = Board::new(state, regions_clone, grid_size);
    run_tiers_1_through_6(&mut with_branch);

    classify_solver_step(&before, &deterministic.state, &with_branch.state)
}

/// Returns true when blocking [candidate_idx] leaves no valid next propagation step.
pub fn is_first_move_forced(
    state: &[u8],
    regions: &[u8],
    grid_size: u32,
    candidate_idx: usize,
) -> bool {
    if candidate_idx >= state.len() || state[candidate_idx] != EMPTY {
        return false;
    }
    let mut blocked = state.to_vec();
    blocked[candidate_idx] = BLOCKED;
    propagate_next_move_index(blocked, regions.to_vec(), grid_size) == -1
}

/// Returns cell index 0..(N²-1) for the next **uniqueness-forced** cat (Tiers 1–5 only).
///
/// * `-2` ([BRANCH_REQUIRED]): propagation finds a move but block-test shows alternates,
///   or T1–T5 stall and T6 can advance.
/// * `-1`: invalid input or fully stuck.
#[flutter_rust_bridge::frb(sync)]
pub fn calculate_next_move(state: Vec<u8>, regions: Vec<u8>, grid_size: u32) -> i32 {
    let idx = propagate_next_move_index(state.clone(), regions.clone(), grid_size);
    if idx >= 0 && !is_first_move_forced(&state, &regions, grid_size, idx as usize) {
        return BRANCH_REQUIRED;
    }
    idx
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::board::{BLOCKED, CAT};
    use crate::solver::test_helpers::{checkerboard_regions, quadrant_regions};
    use crate::solver::t6_fixtures::T6_FIXTURE_GATE;

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
    fn seq01_phase2_golden_hint_api() {
        let state = vec![
            0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        ];
        let regions = vec![
            2, 1, 3, 1, 2, 1, 1, 1, 2, 2, 3, 1, 2, 3, 3, 1,
        ];
        assert_eq!(propagate_next_move_index(state.clone(), regions.clone(), 4), 4);
        assert_eq!(calculate_next_move(state, regions, 4), BRANCH_REQUIRED);
    }

    #[test]
    fn seq02_phase2_golden_hint_api() {
        let state = vec![
            0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        ];
        let regions = vec![
            2, 2, 2, 2, 2, 3, 2, 1, 6, 2, 2, 2, 5, 1, 1, 1, 1, 2, 1, 1, 3, 3, 2, 2,
            1, 1, 3, 3, 3, 3, 1, 1, 1, 1, 4, 3,
        ];
        assert_eq!(propagate_next_move_index(state.clone(), regions.clone(), 6), 8);
        assert_eq!(calculate_next_move(state, regions, 6), BRANCH_REQUIRED);
    }

    #[test]
    fn classify_returns_forced_index_when_t5_places_cat() {
        let before = vec![EMPTY, BLOCKED, EMPTY, BLOCKED];
        let after_t5 = vec![CAT, BLOCKED, EMPTY, BLOCKED];
        let after_t6 = vec![CAT, BLOCKED, CAT, BLOCKED];
        assert_eq!(classify_solver_step(&before, &after_t5, &after_t6), 0);
    }

    #[test]
    fn classify_returns_branch_required_when_only_t6_places_cat() {
        let before = vec![EMPTY, BLOCKED, EMPTY, BLOCKED];
        let after_t5 = before.clone();
        let after_t6 = vec![EMPTY, BLOCKED, CAT, BLOCKED];
        assert_eq!(
            classify_solver_step(&before, &after_t5, &after_t6),
            BRANCH_REQUIRED
        );
    }

    #[test]
    fn classify_returns_minus_one_when_neither_tier_places_cat() {
        let before = vec![EMPTY, BLOCKED];
        let stalled = before.clone();
        assert_eq!(classify_solver_step(&before, &stalled, &stalled), -1);
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

        assert_eq!(calculate_next_move(state, regions, size), BRANCH_REQUIRED);
    }

    /// H1 — t6 regression-lock boards return branch when propagation move is not unique.
    #[test]
    fn t6_gate_boards_return_branch_when_not_unique() {
        for golden in T6_FIXTURE_GATE {
            let hint = calculate_next_move(
                golden.state.to_vec(),
                golden.regions.to_vec(),
                golden.grid_size,
            );
            assert_eq!(
                hint,
                BRANCH_REQUIRED,
                "{} hint API should be branch when not unique-forced",
                golden.fixture
            );
        }
    }
}
