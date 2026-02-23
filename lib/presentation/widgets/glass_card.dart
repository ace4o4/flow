import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forgeflow/core/config/app_theme.dart';
import 'package:forgeflow/presentation/widgets/tap_scale.dart';

/// Frosted glass card with subtle glow — Neo Tactile style.
/// Backdrop blur + translucent fill + glowing shadow.
/// Automatically wraps in TapScale when [onTap] is provided.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? glowColor;
  final bool compact;
  final double blur;
  final bool isInset;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = 20,
    this.onTap,
    this.glowColor,
    this.compact = false,
    this.blur = 16,
    this.isInset = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget card = Container(
      padding: compact ? const EdgeInsets.all(14) : padding,
      decoration: AppTheme.neoCard(
        isDark: isDark,
        radius: borderRadius,
        isInset: isInset,
      ),
      child: child,
    );

    if (onTap != null) {
      return TapScale(onTap: onTap, child: card);
    }
    return card;
  }
}
