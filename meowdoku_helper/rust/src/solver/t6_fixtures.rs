//! Locked parse output + expected next-move index for T6 fixture gate (seq 22–30).
//! Parse arrays: parse-lock. expected_move: regression-lock (QA re-audit P1 — TEST_PLAN.md).
//! QA-owned oracle — Coder must not edit to force green. See doc/plan/FIXTURES.md.

pub struct T6SolverGolden {
    pub fixture: &'static str,
    pub grid_size: u32,
    pub state: &'static [u8],
    pub regions: &'static [u8],
    pub expected_move: i32,
}

const SEQ22_STATE: [u8; 64] = [0; 64];
const SEQ22_REGIONS: [u8; 64] = [
    8, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 5, 5, 3, 6, 6, 6, 6, 5, 5, 5, 5, 1, 2, 2, 2, 2, 2, 5, 2,
    1, 2, 2, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 4, 1, 7, 1, 1, 4, 4, 1, 4, 4, 4, 4, 4, 4, 4,
];

const SEQ23_STATE: [u8; 81] = [0; 81];
const SEQ23_REGIONS: [u8; 81] = [
    1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 1, 5, 5, 5, 5, 3, 3, 1, 4, 1, 5, 3, 3, 5, 3, 1, 1, 4, 5, 5, 7, 3,
    5, 3, 1, 1, 4, 4, 5, 7, 3, 3, 3, 3, 1, 4, 4, 2, 7, 6, 3, 8, 8, 1, 4, 2, 2, 7, 6, 1, 1, 1, 1, 4,
    4, 2, 6, 6, 6, 9, 2, 1, 4, 2, 2, 2, 2, 2, 2, 2, 2,
];

const SEQ24_STATE: [u8; 100] = [
    0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0,
    0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
    0, 0, 0, 0,
];
const SEQ24_REGIONS: [u8; 100] = [
    5, 5, 5, 5, 2, 5, 5, 5, 8, 8, 5, 4, 4, 4, 6, 4, 2, 5, 5, 5, 4, 4, 1, 4, 6, 3, 2, 2, 2, 2, 4, 4,
    1, 4, 3, 3, 2, 3, 2, 2, 6, 3, 3, 3, 4, 1, 2, 3, 6, 6, 6, 3, 3, 3, 1, 1, 2, 3, 6, 2, 1, 1, 1, 3,
    3, 3, 3, 3, 6, 2, 7, 7, 1, 1, 2, 1, 3, 6, 6, 2, 7, 7, 1, 1, 3, 3, 3, 6, 6, 6, 1, 1, 1, 3, 3, 3,
    3, 6, 9, 6,
];

const SEQ25_STATE: [u8; 100] = [
    0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,
    2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
    0, 0, 0, 0,
];
const SEQ25_REGIONS: [u8; 100] = [
    1, 9, 1, 1, 5, 5, 5, 5, 5, 3, 1, 1, 1, 5, 5, 5, 1, 1, 5, 3, 1, 2, 1, 1, 2, 7, 1, 6, 6, 3, 1, 2,
    1, 1, 2, 5, 6, 6, 2, 3, 2, 2, 7, 2, 1, 1, 6, 5, 2, 2, 1, 2, 2, 5, 1, 2, 6, 8, 2, 3, 1, 4, 2, 2,
    2, 2, 2, 2, 2, 3, 1, 4, 4, 7, 2, 7, 2, 3, 3, 3, 1, 4, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4, 4, 4, 4, 4,
    3, 3, 3, 3,
];

const SEQ26_STATE: [u8; 81] = [0; 81];
const SEQ26_REGIONS: [u8; 81] = [
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 7, 7, 7, 7, 7, 1, 1, 8, 4, 4, 6, 6, 6, 2, 1, 1, 8, 4, 6, 6, 3, 6,
    2, 1, 8, 8, 4, 4, 4, 3, 2, 2, 1, 1, 2, 5, 5, 4, 3, 2, 1, 1, 2, 2, 5, 3, 3, 3, 2, 2, 1, 1, 2, 5,
    5, 3, 3, 2, 2, 2, 1, 2, 5, 9, 3, 3, 2, 2, 2, 2, 2,
];

const SEQ27_STATE: [u8; 81] = [0; 81];
const SEQ27_REGIONS: [u8; 81] = [
    2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 4, 4, 2, 2, 2, 3, 2, 3, 4, 4, 2, 2, 3, 3, 3, 2, 3, 4, 4, 1, 1, 1,
    3, 3, 3, 3, 4, 4, 4, 4, 1, 3, 7, 7, 7, 6, 1, 1, 1, 1, 3, 3, 3, 5, 6, 6, 6, 6, 1, 1, 5, 5, 5, 1,
    1, 1, 1, 1, 5, 5, 5, 8, 9, 9, 1, 1, 1, 1, 5, 8, 8,
];

const SEQ28_STATE: [u8; 100] = [
    0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0,
    0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
    0, 0, 0, 0,
];
const SEQ28_REGIONS: [u8; 100] = [
    6, 6, 6, 2, 10, 2, 2, 2, 2, 2, 6, 6, 5, 5, 5, 5, 2, 2, 2, 2, 7, 4, 4, 4, 2, 9, 3, 3, 3, 2, 7, 7,
    7, 4, 6, 10, 3, 8, 3, 2, 7, 4, 4, 4, 4, 5, 7, 8, 3, 2, 7, 4, 4, 10, 4, 5, 3, 8, 3, 2, 1, 1, 9, 4,
    4, 5, 3, 8, 3, 2, 1, 4, 4, 4, 4, 5, 3, 3, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 1,
    1, 1, 2,
];

const SEQ29_STATE: [u8; 100] = [0; 100];
const SEQ29_REGIONS: [u8; 100] = [
    1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 3, 1, 1, 2, 2, 1, 10, 6, 6, 6, 3, 1, 1, 1, 2, 1, 1, 6, 5, 5, 3, 3,
    1, 2, 2, 6, 6, 6, 6, 5, 3, 1, 1, 2, 2, 2, 2, 2, 6, 5, 3, 2, 2, 2, 4, 2, 7, 2, 2, 5, 3, 2, 3, 4,
    4, 4, 7, 2, 5, 5, 3, 2, 3, 4, 7, 4, 7, 8, 9, 5, 3, 3, 3, 4, 7, 7, 7, 8, 5, 5, 3, 4, 4, 4, 4, 4,
    4, 8, 5, 5,
];

const SEQ30_STATE: [u8; 100] = [0; 100];
const SEQ30_REGIONS: [u8; 100] = [
    2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 2, 2, 3, 3, 3, 3, 3, 3, 1, 3, 2, 1, 1, 1, 3, 1, 1, 1, 1, 3, 2, 2,
    2, 1, 3, 3, 1, 1, 6, 3, 2, 9, 2, 1, 1, 3, 1, 6, 6, 3, 9, 9, 2, 7, 1, 1, 1, 1, 6, 6, 5, 4, 4, 7,
    7, 4, 1, 1, 1, 6, 5, 5, 4, 4, 4, 4, 4, 4, 1, 6, 5, 5, 4, 5, 4, 10, 8, 8, 1, 6, 5, 5, 5, 5, 4, 4,
    4, 8, 6, 6,
];

pub const T6_FIXTURE_GATE: &[T6SolverGolden] = &[
    T6SolverGolden {
        fixture: "22_L31_N8_T6.jpeg",
        grid_size: 8,
        state: &SEQ22_STATE,
        regions: &SEQ22_REGIONS,
        expected_move: 0,
    },
    T6SolverGolden {
        fixture: "23_L22_N9_T6.jpeg",
        grid_size: 9,
        state: &SEQ23_STATE,
        regions: &SEQ23_REGIONS,
        expected_move: 8,
    },
    T6SolverGolden {
        fixture: "24_L27_N9_T6.jpeg",
        grid_size: 10,
        state: &SEQ24_STATE,
        regions: &SEQ24_REGIONS,
        expected_move: 9,
    },
    T6SolverGolden {
        fixture: "25_L32_N9_T6.jpeg",
        grid_size: 10,
        state: &SEQ25_STATE,
        regions: &SEQ25_REGIONS,
        expected_move: 1,
    },
    T6SolverGolden {
        fixture: "26_L29_N9_T6.jpeg",
        grid_size: 9,
        state: &SEQ26_STATE,
        regions: &SEQ26_REGIONS,
        expected_move: 7,
    },
    T6SolverGolden {
        fixture: "27_L24_N9_T6.jpeg",
        grid_size: 9,
        state: &SEQ27_STATE,
        regions: &SEQ27_REGIONS,
        expected_move: 4,
    },
    T6SolverGolden {
        fixture: "28_L30_N9_T6.jpeg",
        grid_size: 10,
        state: &SEQ28_STATE,
        regions: &SEQ28_REGIONS,
        expected_move: 9,
    },
    T6SolverGolden {
        fixture: "29_L23_N10_T6.jpeg",
        grid_size: 10,
        state: &SEQ29_STATE,
        regions: &SEQ29_REGIONS,
        expected_move: 2,
    },
    T6SolverGolden {
        fixture: "30_L25_N10_T6.jpeg",
        grid_size: 10,
        state: &SEQ30_STATE,
        regions: &SEQ30_REGIONS,
        expected_move: 6,
    },
];

#[cfg(test)]
mod tests {
    use super::*;
    use crate::api::meowdoku::calculate_next_move;

    #[test]
    fn t6_fixture_gate_returns_expected_moves() {
        for golden in T6_FIXTURE_GATE {
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
