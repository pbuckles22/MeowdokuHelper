/// FFI `calculate_next_move` return codes (row-major index or sentinel).
abstract final class SolverResult {
  /// Tier 6 branch required — not a deterministic hint.
  static const int branchRequired = -2;

  /// Invalid input or fully stuck.
  static const int stalled = -1;

  static bool isForcedMove(int index) => index >= 0;
}
