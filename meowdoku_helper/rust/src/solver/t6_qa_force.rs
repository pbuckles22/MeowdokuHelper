//! QA-only: verify whether a candidate first-move index is logically forced.
//!
//! Forced ⟺ blocking that cell leaves no valid next move (`calculate_next_move` → -1).
//! If another first move exists, the locked index is a T6 branch convention, not a hint.
//! See doc/qa_derivations/t6-seq22-30-human.md.

use crate::api::meowdoku::calculate_next_move;
use crate::solver::board::BLOCKED;

/// Returns true when `candidate_idx` is EMPTY and blocking it stalls the solver.
pub fn is_first_move_forced(
    state: &[u8],
    regions: &[u8],
    grid_size: u32,
    candidate_idx: usize,
) -> bool {
    if candidate_idx >= state.len() || state[candidate_idx] != 0 {
        return false;
    }
    let mut blocked = state.to_vec();
    blocked[candidate_idx] = BLOCKED;
    calculate_next_move(blocked, regions.to_vec(), grid_size) == -1
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::solver::t6_fixtures::T6_FIXTURE_GATE;

    /// QA gate: classify locked t6 moves as forced vs branch-variant (not failing — report).
    #[test]
    fn t6_locked_moves_uniqueness_report() {
        let mut forced = 0u32;
        let mut branch = 0u32;
        for golden in T6_FIXTURE_GATE {
            let idx = golden.branch_probe_index as usize;
            let is_forced = is_first_move_forced(
                golden.state,
                golden.regions,
                golden.grid_size,
                idx,
            );
            eprintln!(
                "{} probe {} ({}) → {}",
                golden.fixture,
                golden.branch_probe_index,
                if is_forced { "FORCED" } else { "BRANCH_VARIANT" },
                if is_forced {
                    "ok for hint UI"
                } else {
                    "DFS convention only — not a forced hint"
                }
            );
            if is_forced {
                forced += 1;
            } else {
                branch += 1;
            }
        }
        eprintln!("t6 uniqueness summary: forced={forced} branch_variant={branch}");
        // Informational — do not fail gate on branch variants until goldens are re-oracled.
    }
}
