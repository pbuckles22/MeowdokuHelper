import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/services/ffi_service.dart';

import 'support/native_ffi.dart';

Future<void> main() async {
  final skip = await nativeFfiSkipReason();

  group('FFI smoke', () {
    test(
      'RustLib.init and FfiService.initialize succeed',
      () async {
        await ensureRustLibInitialized();
        await FfiService.initialize();
        expect(FfiService.isInitialized, isTrue);
      },
      skip: skip,
    );
  });
}
