import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedMeshBackground extends StatefulWidget {
  final List<Color>? orbColors;

  const AnimatedMeshBackground({super.key, this.orbColors});

  @override
  State<AnimatedMeshBackground> createState() => _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground>
    with TickerProviderStateMixin {
  late final List<_OrbData> _orbs;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final rng = Random(42);
    final colors = widget.orbColors ??
        [
          const Color(0xFF00FFAA).withValues(alpha: 0.25),
          const Color(0xFF9D00FF).withValues(alpha: 0.20),
          const Color(0xFF00E5FF).withValues(alpha: 0.18),
          const Color(0xFF0066FF).withValues(alpha: 0.15),
        ];

    _orbs = List.generate(colors.length, (i) {
      return _OrbData(
        color: colors[i],
        baseX: 0.1 + rng.nextDouble() * 0.8,
        baseY: 0.1 + rng.nextDouble() * 0.8,
        radius: 100 + rng.nextDouble() * 120,
        speedX: 0.3 + rng.nextDouble() * 0.7,
        speedY: 0.3 + rng.nextDouble() * 0.7,
        phaseX: rng.nextDouble() * 2 * pi,
        phaseY: rng.nextDouble() * 2 * pi,
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _MeshPainter(_orbs, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _OrbData {
  final Color color;
  final double baseX, baseY, radius;
  final double speedX, speedY, phaseX, phaseY;

  _OrbData({
    required this.color,
    required this.baseX,
    required this.baseY,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.phaseX,
    required this.phaseY,
  });
}

class _MeshPainter extends CustomPainter {
  final List<_OrbData> orbs;
  final double t;

  _MeshPainter(this.orbs, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Dark base
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF0A0A0F),
    );

    for (final orb in orbs) {
      final angle = t * 2 * pi;
      final cx = (orb.baseX + 0.12 * sin(angle * orb.speedX + orb.phaseX)) *
          size.width;
      final cy = (orb.baseY + 0.12 * cos(angle * orb.speedY + orb.phaseY)) *
          size.height;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [orb.color, orb.color.withValues(alpha: 0)],
        ).createShader(
          Rect.fromCircle(center: Offset(cx, cy), radius: orb.radius),
        );

      canvas.drawCircle(Offset(cx, cy), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_MeshPainter old) => true;
}
