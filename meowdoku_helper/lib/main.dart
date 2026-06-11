import 'package:flutter/material.dart';
import 'package:meowdoku_helper/app/clipboard_lifecycle.dart';
import 'package:meowdoku_helper/image/clipboard_parse.dart';
import 'package:meowdoku_helper/service_locator.dart';

void main() {
  runApp(const MeowdokuHelperApp());
}

/// Placeholder shell until Star Battle UI lands (Phase 2/3).
class MeowdokuHelperApp extends StatefulWidget {
  /// Creates the root app widget.
  const MeowdokuHelperApp({super.key});

  @override
  State<MeowdokuHelperApp> createState() => _MeowdokuHelperAppState();
}

class _MeowdokuHelperAppState extends State<MeowdokuHelperApp> {
  late final Future<void> _initFuture;
  String _status = 'Initializing Rust FFI…';
  bool _ffiReady = false;
  bool _parsingClipboard = false;

  @override
  void initState() {
    super.initState();
    _initFuture = _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await setupServices();
      if (mounted) {
        setState(() {
          _ffiReady = true;
          _status = 'Rust bridge ready';
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _status = 'FFI init failed: $e');
      }
      rethrow;
    }
  }

  Future<void> _checkClipboardForImage() async {
    if (!_ffiReady || _parsingClipboard) {
      return;
    }

    setState(() {
      _parsingClipboard = true;
      _status = 'Checking clipboard…';
    });

    try {
      final result = await parseClipboardImageIfJpeg(
        readClipboardBytes: readPasteboardImageBytes,
      );

      if (!mounted) {
        return;
      }

      if (result == null) {
        setState(() => _status = 'Clipboard: no JPEG image');
      } else {
        final n = result.parsed.gridSize;
        setState(
          () => _status = 'Parsed N=$n grid from clipboard (isolate)',
        );
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _status = 'Clipboard parse failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _parsingClipboard = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => ClipboardLifecycleListener(
    onResumed: _checkClipboardForImage,
    child: MaterialApp(
      title: 'MeowdokuHelper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          final ready =
              snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError;

          return Scaffold(
            appBar: AppBar(
              title: const Text('MeowdokuHelper'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      ready ? Icons.pets : Icons.hourglass_top,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      ready ? 'Star Battle solver' : 'Starting…',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(_status, textAlign: TextAlign.center),
                    if (!ready &&
                        snapshot.connectionState != ConnectionState.done)
                      const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: CircularProgressIndicator(),
                      ),
                    if (snapshot.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          '${snapshot.error}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
