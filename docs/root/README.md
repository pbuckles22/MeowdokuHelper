# meowdoku_helper Bolt-On Project

## 🚨 **FOR FUTURE AGENTS: START HERE**

This is a **BOLT-ON project** - you are adding meowdoku_helper functionality to an existing Flutter-Rust FFI template.

### **📚 Essential Documentation**

1. **START HERE**: [`docs/MEOWDOKU_HELPER_COMPLEXITY_FOR_FUTURE_AGENTS.md`](docs/MEOWDOKU_HELPER_COMPLEXITY_FOR_FUTURE_AGENTS.md)
   - **CRITICAL**: Read this first to understand what meowdoku_helper actually is
   - Explains it's an AI-powered solver, not simple word validation

2. **IMPLEMENTATION GUIDE**: [`docs/NEW_PROJECT_PLAN_WITH_MEOWDOKU_HELPER_UNDERSTANDING.md`](docs/NEW_PROJECT_PLAN_WITH_MEOWDOKU_HELPER_UNDERSTANDING.md)
   - Step-by-step bolt-on process
   - Copy-paste instructions from reference implementation
   - Clear timeline and success metrics

### **🎯 Quick Start**

```bash
# 1. Verify current state
cd my_working_ffi_app
flutter test                    # Should pass (700+ tests)
cargo build --release          # Should compile successfully

# 2. Study reference implementation
cat /Users/chaos/dev/meowdoku_helper_reference/README.md
cat /Users/chaos/dev/meowdoku_helper_reference/src/intelligent_solver.rs

# 3. Start copy-paste process
# Target: my_working_ffi_app/rust/src/api/simple.rs
# First function: calculate_entropy() from reference
```

### **📁 Project Structure**

- `my_working_ffi_app/` - Main Flutter app with working FFI bridge
- `docs/` - All documentation (consolidated)
- `rust/` - Standalone Rust build artifacts
- `scripts/` - Utility scripts

### **🎯 Success Metrics**

- **99.8% success rate** (vs 89% human average)
- **3.66 average guesses** to solve any Wordle
- **< 200ms response time** for complex analysis
- **< 50MB memory usage**

### **🧪 Testing Strategy**

- **Algorithm-Testing Word List**: 1,273 strategically curated words
- **Comprehensive Coverage**: Shannon Entropy, statistical analysis, pattern recognition
- **Fast Execution**: ~1 second test suite (13x faster than full 17,169-word list)
- **No Complexity**: Eliminated `fastTestMode` - single consistent approach
- **Full FFI Testing**: All tests use real Rust solver with intelligent suggestions

See [`docs/TESTING_STRATEGY.md`](docs/TESTING_STRATEGY.md) for detailed testing approach.

### **⚠️ Critical Warning**

**meowdoku_helper is NOT a simple word validation tool. It's a sophisticated AI-powered Star Battle solver with advanced algorithms including Shannon Entropy Analysis, Statistical Analysis, and Look-Ahead Strategy.**

**Any agent that treats this as simple word validation will create massive technical debt and fail to deliver the required functionality.**

---

**Status**: Ready for meowdoku_helper bolt-on implementation  
**Template**: Clean Flutter-Rust FFI (Julia disabled)  
**Reference**: `/Users/chaos/dev/meowdoku_helper_reference/` (complete working implementation)