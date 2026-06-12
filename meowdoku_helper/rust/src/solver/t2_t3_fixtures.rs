//! Locked parse output + expected next-move index for T2/T3 fixture gate (seq 09–17).
//! Parse arrays: parse-lock (Q5 2026-06-12). expected_move: regression-lock (QA derivation).
//! QA-owned oracle — Coder must not edit to force green. See doc/plan/FIXTURES.md.

pub struct T2T3SolverGolden {
    pub fixture: &'static str,
    pub seq: u8,
    pub min_tier: u8,
    pub grid_size: u32,
    pub state: &'static [u8],
    pub regions: &'static [u8],
    /// Forced move from T1–T5 (`calculate_next_move`); must not be BRANCH_REQUIRED (-2).
    pub expected_move: i32,
}

const SEQ09_STATE: [u8; 49] = [0; 49];
const SEQ09_REGIONS: [u8; 49] = [
    6, 3, 2, 2, 7, 4, 4, 6, 5, 5, 2, 7, 7, 4, 6, 5, 5, 2, 4, 4, 4, 5, 5, 3, 2, 1, 1, 1, 3, 3, 3,
    2, 1, 1, 1, 3, 3, 3, 2, 1, 1, 1, 3, 3, 2, 2, 2, 1, 1,
];

const SEQ10_STATE: [u8; 36] = [0; 36];
const SEQ10_REGIONS: [u8; 36] = [
    1, 1, 1, 1, 1, 1, 1, 1, 5, 1, 2, 1, 1, 1, 1, 2, 2, 4, 1, 3, 1, 6, 2, 2, 3, 3, 3, 3, 3, 2, 3, 3,
    3, 2, 2, 2,
];

const SEQ11_STATE: [u8; 36] = [0; 36];
const SEQ11_REGIONS: [u8; 36] = [
    3, 3, 3, 3, 3, 2, 1, 3, 6, 3, 4, 2, 1, 3, 4, 4, 4, 2, 1, 1, 1, 2, 4, 2, 1, 2, 2, 2, 2, 2, 1, 1,
    1, 1, 1, 5,
];

const SEQ12_STATE: [u8; 81] = [
    0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
    0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0,
];
const SEQ12_REGIONS: [u8; 81] = [
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 5, 7, 2, 2, 2, 4, 4, 5, 9, 5, 5, 2, 2, 4, 4, 1, 1, 5,
    5, 3, 3, 2, 4, 4, 9, 1, 1, 5, 3, 3, 2, 1, 1, 1, 1, 1, 5, 3, 3, 2, 1, 6, 1, 1, 1, 1, 3, 3, 3, 6, 6,
    6, 1, 1, 8, 3, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3,
];

const SEQ13_STATE: [u8; 81] = SEQ12_STATE;
const SEQ13_REGIONS: [u8; 81] = [
    2, 3, 3, 3, 3, 3, 1, 1, 1, 2, 3, 3, 6, 6, 3, 3, 1, 1, 2, 2, 3, 6, 9, 3, 1, 1, 7, 2, 2, 6, 6, 6,
    1, 1, 1, 1, 2, 2, 9, 6, 6, 1, 1, 1, 1, 2, 2, 6, 6, 6, 6, 8, 1, 1, 4, 2, 2, 5, 5, 5, 5, 1, 1, 4,
    2, 2, 5, 5, 4, 5, 5, 1, 4, 4, 4, 4, 4, 4, 4, 5, 5,
];

const SEQ14_STATE: [u8; 144] = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
];
const SEQ14_REGIONS: [u8; 144] = [
    2, 1, 1, 11, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 6, 7, 7, 7, 1, 2, 1, 1, 2, 2, 1, 1, 6,
    6, 7, 1, 1, 11, 11, 1, 1, 11, 11, 11, 12, 6, 7, 11, 11, 2, 2, 1, 11, 1, 1, 1, 6, 6, 6, 1, 4, 10,
    2, 2, 2, 2, 2, 1, 6, 4, 4, 4, 4, 2, 2, 3, 11, 9, 2, 6, 6, 4, 4, 3, 4, 2, 8, 3, 11, 6, 6, 6, 3, 3,
    3, 3, 4, 2, 8, 8, 3, 3, 3, 3, 3, 3, 3, 4, 4, 2, 8, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 3, 3, 11, 5,
    3, 5, 5, 3, 3, 3, 4, 5, 5, 5, 12, 5, 5, 5, 4, 4, 4, 4, 4,
];

const SEQ15_STATE: [u8; 81] = SEQ12_STATE;
const SEQ15_REGIONS: [u8; 81] = [
    3, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 2, 4, 4, 4, 3, 8, 2, 3, 9, 2, 2, 1, 4, 3, 2, 2, 2, 3,
    2, 1, 1, 1, 3, 2, 9, 2, 2, 2, 1, 1, 1, 3, 3, 3, 2, 2, 2, 1, 1, 6, 5, 5, 5, 2, 2, 1, 1, 1, 1, 5,
    2, 2, 2, 2, 1, 1, 1, 1, 5, 5, 5, 5, 5, 1, 7, 1, 1,
];

const SEQ16_STATE: [u8; 100] = [
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0,
];
const SEQ16_REGIONS: [u8; 100] = [
    2, 2, 2, 2, 10, 10, 2, 2, 2, 2, 2, 4, 2, 4, 10, 10, 4, 4, 2, 3, 2, 4, 4, 4, 10, 10, 4, 3, 3, 3, 4,
    4, 1, 1, 10, 10, 4, 4, 5, 3, 10, 10, 10, 10, 1, 5, 10, 10, 10, 10, 10, 9, 10, 10, 1, 5, 5, 10, 10,
    10, 6, 6, 6, 1, 1, 10, 5, 3, 5, 3, 6, 7, 8, 1, 10, 1, 3, 3, 3, 3, 6, 7, 7, 7, 10, 1, 1, 3, 3, 1,
    6, 6, 7, 7, 10, 1, 1, 1, 1, 1,
];

const SEQ17_STATE: [u8; 100] = [0; 100];
const SEQ17_REGIONS: [u8; 100] = [
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 7, 7, 7, 1, 1, 1, 6, 6, 1, 1, 1, 7, 1, 1, 1, 1, 4, 6, 1, 5, 5,
    1, 1, 4, 4, 4, 4, 6, 2, 5, 1, 1, 1, 1, 4, 4, 6, 6, 2, 5, 5, 5, 5, 1, 4, 8, 8, 6, 2, 2, 10, 1, 1, 1,
    4, 4, 4, 9, 2, 2, 3, 3, 3, 3, 3, 3, 4, 9, 2, 2, 3, 2, 2, 3, 2, 3, 4, 3, 2, 2, 2, 2, 2, 2, 2, 3, 3,
    3,
];

pub const T2_T3_FIXTURE_GATE: &[T2T3SolverGolden] = &[
    T2T3SolverGolden {
        fixture: "09_L10_N7_T2.jpg",
        seq: 9,
        min_tier: 2,
        grid_size: 7,
        state: &SEQ09_STATE,
        regions: &SEQ09_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "10_L11_T2.jpeg",
        seq: 10,
        min_tier: 2,
        grid_size: 6,
        state: &SEQ10_STATE,
        regions: &SEQ10_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "11_L12_T2.jpeg",
        seq: 11,
        min_tier: 2,
        grid_size: 6,
        state: &SEQ11_STATE,
        regions: &SEQ11_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "12_L13_T2.jpeg",
        seq: 12,
        min_tier: 2,
        grid_size: 9,
        state: &SEQ12_STATE,
        regions: &SEQ12_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "13_L14_T2.jpeg",
        seq: 13,
        min_tier: 2,
        grid_size: 9,
        state: &SEQ13_STATE,
        regions: &SEQ13_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "14_L15_N10_T3.jpeg",
        seq: 14,
        min_tier: 3,
        grid_size: 12,
        state: &SEQ14_STATE,
        regions: &SEQ14_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "15_L16_T3.jpeg",
        seq: 15,
        min_tier: 3,
        grid_size: 9,
        state: &SEQ15_STATE,
        regions: &SEQ15_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "16_L17_T3.jpeg",
        seq: 16,
        min_tier: 3,
        grid_size: 10,
        state: &SEQ16_STATE,
        regions: &SEQ16_REGIONS,
        expected_move: -2,
    },
    T2T3SolverGolden {
        fixture: "17_L18_T3.jpeg",
        seq: 17,
        min_tier: 3,
        grid_size: 10,
        state: &SEQ17_STATE,
        regions: &SEQ17_REGIONS,
        expected_move: -2,
    },
];

#[cfg(test)]
mod tests {
    use super::*;
    use crate::api::meowdoku::{calculate_next_move, BRANCH_REQUIRED};
    use crate::solver::board::Board;
    use crate::solver::t6_qa_force::is_first_move_forced;
    use crate::solver::tier2::run_tiers_1_and_2;
    use crate::solver::tier3::run_tiers_1_through_3;
    use crate::solver::tier4::run_tiers_1_through_5;
    use crate::solver::tier1::run_tier1;

    #[test]
    fn q5_oracle_dump_seq_09_17() {
        for golden in T2_T3_FIXTURE_GATE {
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

    fn tier_that_places_first_cat(golden: &T2T3SolverGolden) -> &'static str {
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
        use crate::solver::board::CAT;
        before
            .iter()
            .zip(after.iter())
            .any(|(a, b)| *a != CAT && *b == CAT)
    }

    #[test]
    fn t2_t3_fixture_gate_returns_expected_moves() {
        for golden in T2_T3_FIXTURE_GATE {
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
