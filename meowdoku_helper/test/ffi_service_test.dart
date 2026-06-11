import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku_helper/exceptions/service_exceptions.dart';
import 'package:meowdoku_helper/services/ffi_service.dart';

import 'support/native_ffi.dart';

Future<void> main() async {
  final skip = await nativeFfiSkipReason();

  group('FfiService', () {
    test(
      'initialize succeeds when native lib is linked',
      () async {
        await FfiService.initialize();
        expect(FfiService.isInitialized, isTrue);
      },
      skip: skip,
    );

    test(
      'second initialize is a no-op',
      () async {
        await ensureRustLibInitialized();
        await FfiService.initialize();
        await FfiService.initialize();
        expect(FfiService.isInitialized, isTrue);
      },
      skip: skip,
    );
  });

  group('FfiInitializationException', () {
    test('formats message with optional details', () {
      const ex = FfiInitializationException('dylib missing');
      expect(ex.toString(), contains('Failed to initialize FFI'));
      expect(ex.toString(), contains('dylib missing'));
    });
  });
}
