//! Locked parse output + expected next-move index for T4 fixture gate (seq 18–19).
//! Parse arrays: parse-lock (H2 2026-06-12). expected_move: regression-lock (QA derivation).
//! QA-owned oracle — Coder must not edit to force green. See doc/plan/FIXTURES.md.

pub struct T4SolverGolden {
    pub fixture: &'static str,
    pub seq: u8,
    pub min_tier: u8,
    pub grid_size: u32,
    pub state: &'static [u8],
    pub regions: &'static [u8],
    /// Forced move from T1–T5 (`calculate_next_move`); must not be BRANCH_REQUIRED (-2).
    pub expected_move: i32,
}

const SEQ18_STATE: [u8; 100] = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0,
    0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 2, 0, 0, 0, 0,
];
const SEQ18_REGIONS: [u8; 100] = [
    4, 4, 4, 5, 3, 5, 3, 6, 6, 6, 4, 9, 5, 5, 10, 3, 3, 3, 3, 6, 4, 5, 5, 3, 10, 10, 2, 2, 7, 6,
    4, 3, 3, 3, 10, 10, 2, 7, 7, 7, 10, 10, 10, 10, 3, 2, 10, 10, 10, 10, 4, 3, 10, 10, 2, 2, 2,
    2, 2, 2, 4, 3, 3, 1, 10, 2, 2, 1, 2, 1, 4, 3, 1, 1, 10, 1, 1, 1, 2, 1, 4, 3, 8, 8, 10, 1, 2, 2,
    2, 1, 4, 4, 4, 1, 10, 1, 1, 1, 1, 1,
];

const SEQ19_STATE: [u8; 81] = [
    0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
    0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0,
];
const SEQ19_REGIONS: [u8; 81] = [
    4, 7, 2, 2, 2, 2, 2, 1, 1, 4, 7, 5, 5, 5, 5, 2, 1, 1, 4, 7, 7, 5, 9, 5, 2, 1, 1, 4, 4, 2, 2,
    5, 2, 2, 1, 1, 4, 4, 9, 2, 2, 2, 2, 1, 1, 4, 3, 2, 1, 1, 1, 1, 1, 1, 3, 3, 2, 1, 1, 1, 1, 1,
    1, 3, 3, 2, 2, 2, 2, 2, 6, 6, 3, 3, 8, 8, 8, 8, 8, 6, 6,
];

pub const T4_FIXTURE_GATE: &[T4SolverGolden] = &[
    T4SolverGolden {
        fixture: "18_L19_T4.jpeg",
        seq: 18,
        min_tier: 4,
        grid_size: 10,
        state: &SEQ18_STATE,
        regions: &SEQ18_REGIONS,
        expected_move: -2,
    },
    T4SolverGolden {
        fixture: "19_L20_T4.jpeg",
        seq: 19,
        min_tier: 4,
        grid_size: 9,
        state: &SEQ19_STATE,
        regions: &SEQ19_REGIONS,
        expected_move: -2,
    },
];

#[cfg(test)]
mod tests {
    use super::*;
    use crate::api::meowdoku::{calculate_next_move, BRANCH_REQUIRED};
    use crate::solver::board::Board;
    use crate::solver::t6_qa_force::is_first_move_forced;
    use crate::solver::tier1::run_tier1;
    use crate::solver::tier2::run_tiers_1_and_2;
    use crate::solver::tier3::run_tiers_1_through_3;
    use crate::solver::tier4::run_tiers_1_through_5;
    use crate::solver::board::CAT;

    #[test]
    fn h2_oracle_dump_seq_18_19() {
        for golden in T4_FIXTURE_GATE {
            let idx = calculate_next_move(
                golden.state.to_vec(),
                golden.regions.to_vec(),
                golden.grid_size,
            );
            let forced = if idx >= 0 {
                is_first_move_forced(
                    golden.state,
                    golden.regions,
                    golden.grid_size,
                    idx as usize,
                )
            } else {
                false
            };
            let tier = tier_that_places_first_cat(golden);
            eprintln!(
                "seq {:02} {} N={} move={idx} forced={forced} tier={tier}",
                golden.seq, golden.fixture, golden.grid_size,
            );
            assert_eq!(idx, golden.expected_move, "{} hint API", golden.fixture);
        }
    }

    fn tier_that_places_first_cat(golden: &T4SolverGolden) -> &'static str {
        let before = golden.state.to_vec();
        let mut b1 = Board::new(before.clone(), golden.regions.to_vec(), golden.grid_size);
        run_tier1(&mut b1);
        if cat_delta(&before, &b1.state) {
            return "T1";
        }
        let mut b2 = Board::new(before.clone(), golden.regions.to_vec(), golden.grid_size);
        run_tiers_1_and_2(&mut b2);
        if cat_delta(&before, &b2.state) {
            return "T2";
        }
        let mut b3 = Board::new(before.clone(), golden.regions.to_vec(), golden.grid_size);
        run_tiers_1_through_3(&mut b3);
        if cat_delta(&before, &b3.state) {
            return "T3";
        }
        let mut b5 = Board::new(before, golden.regions.to_vec(), golden.grid_size);
        run_tiers_1_through_5(&mut b5);
        if cat_delta(golden.state, &b5.state) {
            return "T4/T5";
        }
        "none"
    }

    fn cat_delta(before: &[u8], after: &[u8]) -> bool {
        before
            .iter()
            .zip(after.iter())
            .any(|(a, b)| *a != CAT && *b == CAT)
    }

    #[test]
    fn t4_fixture_gate_returns_expected_moves() {
        for golden in T4_FIXTURE_GATE {
            let idx = calculate_next_move(
                golden.state.to_vec(),
                golden.regions.to_vec(),
                golden.grid_size,
            );
            assert_eq!(
                idx, golden.expected_move,
                "fixture {} expected move {}",
                golden.fixture, golden.expected_move
            );
        }
    }
}
