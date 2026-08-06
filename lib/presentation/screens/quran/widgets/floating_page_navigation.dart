import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';

/// Floating left/right navigation buttons that overlay the reading area.
///
/// They fade in when [visible] is true and auto-hide after [autoHideDelay].
/// The buttons are placed at the vertical center of the screen, slightly
/// overlapping the content without displacing it.
class FloatingPageNavigation extends StatefulWidget {
  final bool visible;
  final VoidCallback? onPrevious; // null → disabled
  final VoidCallback? onNext;    // null → disabled
  final int currentPage;         // 1-based
  final int totalPages;
  final Duration autoHideDelay;
  final VoidCallback? onHide;

  const FloatingPageNavigation({
    required this.visible,
    required this.onPrevious,
    required this.onNext,
    required this.currentPage,
    required this.totalPages,
    this.autoHideDelay = const Duration(seconds: 3),
    this.onHide,
    super.key,
  });

  @override
  State<FloatingPageNavigation> createState() =>
      _FloatingPageNavigationState();
}

class _FloatingPageNavigationState extends State<FloatingPageNavigation> {
  Timer? _hideTimer;
  bool _localVisible = false;

  @override
  void initState() {
    super.initState();
    _syncVisibility();
  }

  @override
  void didUpdateWidget(FloatingPageNavigation old) {
    super.didUpdateWidget(old);
    if (widget.visible && !old.visible) _syncVisibility();
    if (!widget.visible && old.visible) {
      _hideTimer?.cancel();
      setState(() => _localVisible = false);
    }
  }

  void _syncVisibility() {
    if (!widget.visible) return;
    _hideTimer?.cancel();
    setState(() => _localVisible = true);
    _hideTimer = Timer(widget.autoHideDelay, () {
      if (mounted) {
        setState(() => _localVisible = false);
        widget.onHide?.call();
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final btnColor = isDark
        ? AppTheme.darkSurfaceColor.withValues(alpha: 0.92)
        : Colors.white.withValues(alpha: 0.92);

    return AnimatedOpacity(
      opacity: _localVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 220),
      child: IgnorePointer(
        ignoring: !_localVisible,
        child: Stack(
          children: [
            // ── Left edge button (RTL: "next" page) ──────────────────
            Positioned(
              left: -4,
              top: 0,
              bottom: 0,
              child: Center(
                child: _NavButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: widget.onNext,
                  color: btnColor,
                  enabled: widget.currentPage < widget.totalPages,
                ),
              ),
            ),

            // ── Right edge button (RTL: "previous" page) ─────────────
            Positioned(
              right: -4,
              top: 0,
              bottom: 0,
              child: Center(
                child: _NavButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: widget.onPrevious,
                  color: btnColor,
                  enabled: widget.currentPage > 1,
                ),
              ),
            ),

            // ── Page indicator (bottom center) ────────────────────────
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: btnColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    '${_toArabicNumber(widget.currentPage)} / ${_toArabicNumber(widget.totalPages)}',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final bool enabled;

  const _NavButton({
    required this.icon,
    required this.onTap,
    required this.color,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 36,
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.13),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            icon,
            size: 22,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

String _toArabicNumber(num value) {
  const w = '0123456789';
  const e = '٠١٢٣٤٥٦٧٨٩';
  return value.toString().split('').map((c) {
    final i = w.indexOf(c);
    return i == -1 ? c : e[i];
  }).join();
}
