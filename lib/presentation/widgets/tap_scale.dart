import 'package:flutter/material.dart';

/// Wrap any tappable widget to get a satisfying press-to-shrink micro-animation.
/// Scales down to [scaleEnd] on press and bounces back on release.
class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleEnd;
  final Duration duration;

  const TapScale({
    super.key,
    required this.child,
    this.onTap,
    this.scaleEnd = 0.96,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween(begin: 1.0, end: widget.scaleEnd).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDown(TapDownDetails _) => _ctrl.forward();
  void _onUp(TapUpDetails _) => _ctrl.reverse();
  void _onCancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? _onDown : null,
      onTapUp: widget.onTap != null ? _onUp : null,
      onTapCancel: widget.onTap != null ? _onCancel : null,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}
