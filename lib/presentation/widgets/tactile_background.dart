import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Animated ambient background with floating gradient orbs.
/// Creates a 3D depth effect behind frosted-glass cards.
class TactileBackground extends StatefulWidget {
  final Widget child;
  const TactileBackground({super.key, required this.child});

  @override
  State<TactileBackground> createState() => _TactileBackgroundState();
}

class _TactileBackgroundState extends State<TactileBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark) return widget.child;

    return Stack(children: [
      // Base gradient
      Positioned.fill(
          child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, -0.6),
            radius: 1.6,
            colors: [
              Color(0xFF0F0F24), // slightly lighter center
              Color(0xFF08080F), // deep dark edge
            ],
          ),
        ),
      )),

      // Animated orbs
      Positioned.fill(
          child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _OrbPainter(_ctrl.value),
          size: Size.infinite,
        ),
      )),

      // Subtle grain/noise overlay for texture
      Positioned.fill(
          child: IgnorePointer(
              child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.008),
              Colors.transparent,
              Colors.white.withValues(alpha: 0.005),
            ],
          ),
        ),
      ))),

      // Subtle grid dots for depth (3D perspective feel)
      Positioned.fill(
          child: IgnorePointer(
              child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _GridPainter(_ctrl.value),
          size: Size.infinite,
        ),
      ))),

      // Content
      widget.child,
    ]);
  }
}

// ── Floating gradient orbs ──
class _OrbPainter extends CustomPainter {
  final double t;
  _OrbPainter(this.t);

  static const _orbs = [
    _Orb(0.2, 0.3, 120, Color(0xFF00D4FF), 0.08, 0.8), // cyan top-left
    _Orb(0.8, 0.2, 100, Color(0xFF6C63FF), 0.06, 1.2), // purple top-right
    _Orb(0.5, 0.6, 160, Color(0xFF00B4D8), 0.05, 0.6), // teal center
    _Orb(0.3, 0.8, 90, Color(0xFFa855f6), 0.04, 1.0), // violet bottom-left
    _Orb(0.75, 0.75, 110, Color(0xFF0891b2), 0.05,
        0.9), // dark cyan bottom-right
    _Orb(0.15, 0.55, 70, Color(0xFF6366f1), 0.035, 1.4), // indigo mid-left
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in _orbs) {
      final phase = t * 2 * pi * orb.speed;
      // Smooth figure-8 / lissajous movement
      final dx = sin(phase + orb.baseX * pi) * size.width * 0.06;
      final dy = cos(phase * 0.7 + orb.baseY * pi) * size.height * 0.04;
      final cx = orb.baseX * size.width + dx;
      final cy = orb.baseY * size.height + dy;

      // Pulsing size
      final r = orb.radius * (1 + sin(phase * 1.3) * 0.15);

      // Radial gradient orb with soft blur
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withValues(alpha: orb.opacity * 1.2),
            orb.color.withValues(alpha: orb.opacity * 0.4),
            orb.color.withValues(alpha: 0),
          ],
          stops: const [0, 0.4, 1],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.4);

      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter old) => true;
}

class _Orb {
  final double baseX, baseY, radius;
  final Color color;
  final double opacity, speed;
  const _Orb(this.baseX, this.baseY, this.radius, this.color, this.opacity,
      this.speed);
}

// ── Subtle perspective grid dots ──
class _GridPainter extends CustomPainter {
  final double t;
  _GridPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.012)
      ..style = PaintingStyle.fill;

    const spacing = 48.0;
    // Slow drift for parallax feel
    final offsetY = (t * spacing * 0.3) % spacing;

    for (double y = -spacing + offsetY;
        y < size.height + spacing;
        y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Fade dots toward edges for vignette
        final distFromCenter =
            ((Offset(x, y) - Offset(size.width / 2, size.height / 2)).distance /
                    (size.width * 0.6))
                .clamp(0.0, 1.0);
        final alpha = 0.012 * (1 - distFromCenter * 0.7);
        if (alpha < 0.002) continue;

        paint.color = Colors.white.withValues(alpha: alpha);
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => true;
}
