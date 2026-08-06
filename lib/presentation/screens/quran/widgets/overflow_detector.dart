import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Wraps [child] in a [SingleChildScrollView].
///
/// After every build it measures the child's natural height with a [GlobalKey]
/// and compares it against [maxHeight]. Scrolling is enabled automatically
/// when the content overflows, and disabled again when it fits (e.g. after a
/// font-size decrease or an orientation change).
///
/// The check retries on subsequent frames if the render object isn't ready yet,
/// so it is robust against first-frame timing issues.
class OverflowDetector extends StatefulWidget {
  final Widget child;
  final double maxHeight;

  const OverflowDetector({
    required this.child,
    required this.maxHeight,
    super.key,
  });

  @override
  State<OverflowDetector> createState() => _OverflowDetectorState();
}

class _OverflowDetectorState extends State<OverflowDetector> {
  final _contentKey = GlobalKey();
  bool _scrollEnabled = false;

  @override
  void initState() {
    super.initState();
    _scheduleCheck();
  }

  @override
  void didUpdateWidget(OverflowDetector old) {
    super.didUpdateWidget(old);
    // Re-measure whenever the available height changes (orientation, etc.)
    if (old.maxHeight != widget.maxHeight) {
      _scheduleCheck();
    }
  }

  void _scheduleCheck() {
    SchedulerBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    if (!mounted) return;

    final ctx = _contentKey.currentContext;
    if (ctx == null) {
      // Render object not attached yet — retry next frame.
      _scheduleCheck();
      return;
    }

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      _scheduleCheck();
      return;
    }

    final contentHeight = box.size.height;
    final overflows = contentHeight > widget.maxHeight + 1; // 1px tolerance

    if (overflows != _scrollEnabled) {
      setState(() => _scrollEnabled = overflows);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Schedule a re-check after every build so a font-size change that causes
    // the content to grow is always detected.
    SchedulerBinding.instance.addPostFrameCallback((_) => _checkOverflow());

    return SingleChildScrollView(
      physics: _scrollEnabled
          ? const ClampingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: SizedBox(
        key: _contentKey,
        child: widget.child,
      ),
    );
  }
}
