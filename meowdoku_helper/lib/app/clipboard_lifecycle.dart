import 'package:flutter/widgets.dart';

/// Fires [onResumed] when the app returns to foreground (US-2.6 pasteboard trigger).
class ClipboardLifecycleListener extends StatefulWidget {
  const ClipboardLifecycleListener({
    required this.onResumed,
    required this.child,
    super.key,
  });

  final VoidCallback onResumed;
  final Widget child;

  @override
  State<ClipboardLifecycleListener> createState() =>
      _ClipboardLifecycleListenerState();
}

class _ClipboardLifecycleListenerState extends State<ClipboardLifecycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.onResumed();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
