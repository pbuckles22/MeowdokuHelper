# Derivation — H3 fixture inventory script

**Session:** 2026-06-12 (Phase 8 H3)

## Artifact

`scripts/fixture_inventory.sh` — lists seq 01–42 on-disk fixtures vs gate tier and FIXTURES.md catalog presence.

## Usage

```bash
./scripts/fixture_inventory.sh          # report; PASS when 42 files + catalog refs
./scripts/fixture_inventory.sh --strict # fail on FIXTURES.md drift
```

## Gate columns (2026-06-12)

| Range | Gate module |
|-------|-------------|
| 01–08 | parse (`grid_goldens.dart`) |
| 09–17 | t2/t3 |
| 18–19 | t4 |
| 22–30 | t6 |
| 20–21, 31–42 | ungated backlog |

Re-run after adding gates; update `gate_for_seq()` in the script when ranges change.
