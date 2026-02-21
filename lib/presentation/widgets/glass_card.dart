import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forgeflow/core/config/app_theme.dart';

/// Frosted glass card with subtle glow — Neo Tactile style.
/// Backdrop blur + translucent fill + glowing shadow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? glowColor;
  final bool compact;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 20,
    this.onTap,
    this.glowColor,
    this.compact = false,
    this.blur = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: isDark ? blur : blur * 0.5,
            sigmaY: isDark ? blur : blur * 0.5),
        child: Container(
          padding: compact ? const EdgeInsets.all(14) : padding,
          decoration: AppTheme.glassCard(
            isDark: isDark,
            glowColor: glowColor,
            radius: borderRadius,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}
