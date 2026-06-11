import 'package:flutter/services.dart';

/// Loads bundled JPEG bytes for Tier 2 integration tests (device/simulator).
Future<Uint8List> loadIntegrationFixture(String filename) async {
  final data = await rootBundle.load('integration_test/fixtures/$filename');
  return data.buffer.asUint8List();
}
