import 'dart:io';

import 'package:meowdoku_helper/src/rust/frb_generated.dart';

/// When non-null, Tier 1b tests that need the native Rust library should skip.
Future<String?> nativeFfiSkipReason() async {
  if (Platform.isWindows) {
    return 'Native Rust lib — run on Mac/iOS';
  }
  try {
    await RustLib.init();
    return null;
  } on Object {
    return 'Native Rust lib not linked — run flutter run or flutter build first';
  }
}

/// Initializes FRB for tests. Call only when [nativeFfiSkipReason] returned null.
Future<void> ensureRustLibInitialized() => RustLib.init();
