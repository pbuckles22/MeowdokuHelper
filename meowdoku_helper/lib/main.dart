import 'package:flutter/material.dart';
import 'package:meowdoku_helper/app/clipboard_flow.dart';
import 'package:meowdoku_helper/app/clipboard_lifecycle.dart';
import 'package:meowdoku_helper/app/puzzle_grid_preview.dart';
import 'package:meowdoku_helper/image/n_detect.dart';
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
  GridParseShell? _parsedShell;
  int? _highlightIndex;

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
      final outcome = await runClipboardParseFlow();

      if (!mounted) {
        return;
      }

      setState(() {
        _parsedShell = outcome.parsedShell;
        _highlightIndex = outcome.highlightIndex;
        _status = outcome.status;
      });
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
                    if (_parsedShell != null && _highlightIndex != null) ...[
                      const SizedBox(height: 24),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: PuzzleGridPreview(
                          gridSize: _parsedShell!.gridSize,
                          state: _parsedShell!.state,
                          highlightIndex: _highlightIndex!,
                        ),
                      ),
                    ],
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
