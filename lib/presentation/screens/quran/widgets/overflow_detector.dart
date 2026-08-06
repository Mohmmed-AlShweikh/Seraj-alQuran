import 'package:flutter/material.dart';

/// Wraps [child] in a [SingleChildScrollView].
/// After the first frame it checks whether the content overflows the
/// available [maxHeight]. If it does, scrolling is enabled automatically;
/// otherwise [NeverScrollableScrollPhysics] keeps the page static.
class OverflowDetector extends StatefulWidget {
  final Widget child;
  final double maxHeight;
  final ScrollController? scrollController;

  const OverflowDetector({
    required this.child,
    required this.maxHeight,
    this.scrollController,
    super.key,
  });

  @override
  State<OverflowDetector> createState() => _OverflowDetectorState();
}

class _OverflowDetectorState extends State<OverflowDetector> {
  late final ScrollController _controller;
  ScrollPhysics _physics = const NeverScrollableScrollPhysics();
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback(_checkOverflow);
  }

  @override
  void didUpdateWidget(OverflowDetector old) {
    super.didUpdateWidget(old);
    if (old.maxHeight != widget.maxHeight) {
      _checked = false;
      WidgetsBinding.instance.addPostFrameCallback(_checkOverflow);
    }
  }

  void _checkOverflow(Duration _) {
    if (_checked || !mounted) return;
    _checked = true;
    if (!_controller.hasClients) return;
    final pos = _controller.position;
    if (pos.maxScrollExtent > 0) {
      setState(() => _physics = const ClampingScrollPhysics());
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      physics: _physics,
      child: widget.child,
    );
  }
}
