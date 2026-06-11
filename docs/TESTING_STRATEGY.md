# Testing strategy (deprecated)

> **Deprecated — June 2026.** This document describes the Wordle-era test architecture
> (algorithm-testing word list, 60+ Wordle tests). For Star Battle, use
> [.cursor/skills/TEST_TDD.md](../.cursor/skills/TEST_TDD.md),
> [TEST_PLAN.md](../TEST_PLAN.md), and [doc/plan/FIXTURES.md](../doc/plan/FIXTURES.md).

---

# 🧪 Testing Strategy: Algorithm-Testing Word List Approach (historical)

## 🎯 **The Problem We Solved**

The meowdoku_helper has 60+ test files. Originally, all tests were using real services that: