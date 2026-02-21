import 'dart:ui';
import 'package:flutter/material.dart';

class GlassInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Color? glowColor;

  const GlassInputField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.hint,
    this.prefixIcon,
    this.glowColor,
  });

  @override
  State<GlassInputField> createState() => _GlassInputFieldState();
}

class _GlassInputFieldState extends State<GlassInputField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glow = widget.glowColor ?? cs.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: _focused
            ? [
                BoxShadow(
                    color: glow.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: -2)
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.white.withValues(alpha: 0.8),
              border: Border.all(
                  color: _focused
                      ? glow.withValues(alpha: 0.3)
                      : cs.onSurface.withValues(alpha: 0.06)),
            ),
            child: Focus(
              onFocusChange: (f) => setState(() => _focused = f),
              child: TextField(
                controller: widget.controller,
                style: TextStyle(
                    color: cs.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText:
                      widget.hintText ?? widget.hint ?? widget.label ?? '',
                  labelText: widget.label,
                  hintStyle:
                      TextStyle(color: cs.onSurface.withValues(alpha: 0.3)),
                  labelStyle:
                      TextStyle(color: cs.onSurface.withValues(alpha: 0.4)),
                  border: InputBorder.none,
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon,
                          color: _focused
                              ? glow
                              : cs.onSurface.withValues(alpha: 0.3))
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
