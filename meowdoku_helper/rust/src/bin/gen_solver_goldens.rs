//! Emit Dart solver golden files from Rust fixture gates (QA SSOT).
//!
//! Run via `./scripts/generate_solver_goldens.sh` from repo root.

use std::fs;
use std::io;
use std::path::PathBuf;

use rust_lib_meowdoku_helper::solver::t2_t3_fixtures::{T2T3SolverGolden, T2_T3_FIXTURE_GATE};
use rust_lib_meowdoku_helper::solver::t4_fixtures::{T4SolverGolden, T4_FIXTURE_GATE};
use rust_lib_meowdoku_helper::solver::t6_fixtures::{T6SolverGolden, T6_FIXTURE_GATE};

const GENERATED_HEADER: &str = "// GENERATED CODE — DO NOT EDIT BY HAND.\n\
// Source of truth: rust/src/solver/*_fixtures.rs (QA-owned oracle).\n\
// Regenerate: ./scripts/generate_solver_goldens.sh\n";

fn main() -> io::Result<()> {
    let manifest_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    let image_dir = manifest_dir.join("../lib/image");

    let t2_t3 = generate_t2_t3()?;
    let t4 = generate_t4()?;
    let t6 = generate_t6()?;

    write_if_changed(&image_dir.join("t2_t3_solver_goldens.dart"), &t2_t3)?;
    write_if_changed(&image_dir.join("t4_solver_goldens.dart"), &t4)?;
    write_if_changed(&image_dir.join("t6_solver_goldens.dart"), &t6)?;

    eprintln!("gen_solver_goldens: wrote 3 Dart files under lib/image/");
    Ok(())
}

fn write_if_changed(path: &PathBuf, content: &str) -> io::Result<()> {
    if path.exists() {
        let existing = fs::read_to_string(path)?;
        if existing == content {
            eprintln!("  unchanged {}", path.display());
            return Ok(());
        }
    }
    fs::write(path, content)?;
    eprintln!("  updated   {}", path.display());
    Ok(())
}

fn is_all_zeros(values: &[u8]) -> bool {
    values.iter().all(|&v| v == 0)
}

fn format_int_array(values: &[u8], indent: &str, per_line: usize) -> String {
    let mut out = String::from("[\n");
    for (i, chunk) in values.chunks(per_line).enumerate() {
        if i > 0 {
            out.push('\n');
        }
        out.push_str(indent);
        let line: Vec<String> = chunk.iter().map(|v| v.to_string()).collect();
        out.push_str(&line.join(", "));
        out.push(',');
    }
    out.push('\n');
    out.push(']');
    out
}

fn generate_t2_t3() -> io::Result<String> {
    let mut out = String::from(GENERATED_HEADER);
    out.push_str(
        "\
/// Locked parse output + expected move for T2/T3 fixture gate (seq 09–17).\n\
/// Generated from `rust/src/solver/t2_t3_fixtures.rs`. See doc/plan/FIXTURES.md.\n\
class T2T3SolverGolden {
  const T2T3SolverGolden({
    required this.fixture,
    required this.seq,
    required this.minTier,
    required this.gridSize,
    required this.state,
    required this.regions,
    required this.expectedMove,
  });

  final String fixture;
  final int seq;
  final int minTier;
  final int gridSize;
  final List<int> state;
  final List<int> regions;
  final int expectedMove;
}


",
    );

    for golden in T2_T3_FIXTURE_GATE {
        emit_seq_arrays(&mut out, golden.seq, golden.state, golden.regions, 16);
    }

    out.push_str("const t2T3FixtureGate = <T2T3SolverGolden>[\n");
    for golden in T2_T3_FIXTURE_GATE {
        emit_t2_t3_entry(&mut out, golden);
    }
    out.push_str("];\n");
    Ok(out)
}

fn emit_seq_arrays(out: &mut String, seq: u8, state: &[u8], regions: &[u8], per_line: usize) {
    let seq_label = format!("{seq:02}");
    out.push_str(&format!("const _seq{seq_label}State = "));
    out.push_str(&format_int_array(state, "  ", per_line));
    out.push_str(";\n\n");
    out.push_str(&format!("const _seq{seq_label}Regions = "));
    out.push_str(&format_int_array(regions, "  ", per_line));
    out.push_str(";\n\n");
}

fn emit_t2_t3_entry(out: &mut String, golden: &T2T3SolverGolden) {
    let seq_label = format!("{:02}", golden.seq);
    out.push_str("  T2T3SolverGolden(\n");
    out.push_str(&format!("    fixture: '{}',\n", golden.fixture));
    out.push_str(&format!("    seq: {},\n", golden.seq));
    out.push_str(&format!("    minTier: {},\n", golden.min_tier));
    out.push_str(&format!("    gridSize: {},\n", golden.grid_size));
    out.push_str(&format!("    state: _seq{seq_label}State,\n"));
    out.push_str(&format!("    regions: _seq{seq_label}Regions,\n"));
    out.push_str(&format!("    expectedMove: {},\n", golden.expected_move));
    out.push_str("  ),\n");
}

fn generate_t4() -> io::Result<String> {
    let mut out = String::from(GENERATED_HEADER);
    out.push_str(
        "\
/// Locked parse output + expected move for T4 fixture gate (seq 18–19).\n\
/// Generated from `rust/src/solver/t4_fixtures.rs`. See doc/plan/FIXTURES.md.\n\
class T4SolverGolden {
  const T4SolverGolden({
    required this.fixture,
    required this.seq,
    required this.minTier,
    required this.gridSize,
    required this.state,
    required this.regions,
    required this.expectedMove,
  });

  final String fixture;
  final int seq;
  final int minTier;
  final int gridSize;
  final List<int> state;
  final List<int> regions;
  final int expectedMove;
}

",
    );

    for golden in T4_FIXTURE_GATE {
        emit_seq_arrays(&mut out, golden.seq, golden.state, golden.regions, 25);
    }

    out.push_str("const List<T4SolverGolden> t4FixtureGate = [\n");
    for golden in T4_FIXTURE_GATE {
        emit_t4_entry(&mut out, golden);
    }
    out.push_str("];\n");
    Ok(out)
}

fn emit_t4_entry(out: &mut String, golden: &T4SolverGolden) {
    let seq_label = format!("{:02}", golden.seq);
    out.push_str("  T4SolverGolden(\n");
    out.push_str(&format!("    fixture: '{}',\n", golden.fixture));
    out.push_str(&format!("    seq: {},\n", golden.seq));
    out.push_str(&format!("    minTier: {},\n", golden.min_tier));
    out.push_str(&format!("    gridSize: {},\n", golden.grid_size));
    out.push_str(&format!("    state: _seq{seq_label}State,\n"));
    out.push_str(&format!("    regions: _seq{seq_label}Regions,\n"));
    out.push_str(&format!("    expectedMove: {},\n", golden.expected_move));
    out.push_str("  ),\n");
}

fn generate_t6() -> io::Result<String> {
    let mut out = String::from(GENERATED_HEADER);
    out.push_str(
        "\
/// Locked parse output + expected move for T6 fixture gate (seq 22–30).\n\
/// Generated from `rust/src/solver/t6_fixtures.rs`. See doc/plan/FIXTURES.md.\n\
class T6SolverGolden {
  const T6SolverGolden({
    required this.fixture,
    required this.gridSize,
    required this.state,
    required this.regions,
    required this.expectedMove,
  });

  final String fixture;
  final int gridSize;
  final List<int> state;
  final List<int> regions;
  final int expectedMove;
}

",
    );

    let mut emitted_state: Vec<u8> = Vec::new();
    for golden in T6_FIXTURE_GATE {
        let seq = t6_seq(golden);
        if !is_all_zeros(golden.state) && !emitted_state.contains(&seq) {
            let seq_label = format!("{seq:02}");
            out.push_str(&format!("const _seq{seq_label}State = "));
            out.push_str(&format_int_array(golden.state, "  ", 32));
            out.push_str(";\n");
            emitted_state.push(seq);
        }
        let seq_label = format!("{seq:02}");
        out.push_str(&format!("const _seq{seq_label}Regions = "));
        out.push_str(&format_int_array(golden.regions, "  ", 32));
        out.push_str(";\n\n");
    }

    out.push_str("List<int> _zeros(int n) => List<int>.filled(n, 0);\n\n");
    out.push_str(
        "/// seq 22–30 gate — parse locked; hint API returns -2 when propagation move is not unique-forced.\n",
    );
    out.push_str("final t6FixtureGate = <T6SolverGolden>[\n");
    for golden in T6_FIXTURE_GATE {
        emit_t6_entry(&mut out, golden);
    }
    out.push_str("];\n");
    Ok(out)
}

fn t6_seq(golden: &T6SolverGolden) -> u8 {
    golden
        .fixture
        .split('_')
        .next()
        .and_then(|s| s.parse().ok())
        .unwrap_or(0)
}

fn emit_t6_entry(out: &mut String, golden: &T6SolverGolden) {
    let seq = t6_seq(golden);
    let seq_label = format!("{seq:02}");
    let state_ref = if is_all_zeros(golden.state) {
        format!("_zeros({})", golden.state.len())
    } else {
        format!("_seq{seq_label}State")
    };
    out.push_str("  T6SolverGolden(\n");
    out.push_str(&format!("    fixture: '{}',\n", golden.fixture));
    out.push_str(&format!("    gridSize: {},\n", golden.grid_size));
    out.push_str(&format!("    state: {state_ref},\n"));
    out.push_str(&format!("    regions: _seq{seq_label}Regions,\n"));
    out.push_str(&format!("    expectedMove: {},\n", golden.expected_move));
    out.push_str("  ),\n");
}
