import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Accent (Cyan Glow) ──
  static const Color accent = Color(0xFF00D4FF);
  static const Color accentAlt = Color(0xFF6C63FF);
  static const Color accentGlow = Color(0xFF00B4D8);

  // ── Status ──
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color orange = Color(0xFFFF8C42);

  // ── Dark Palette (Neo Tactile) ──
  static const Color darkBg = Color(0xFF08080F);
  static const Color darkSurface = Color(0xFF0E0E1A);
  static const Color darkCard = Color(0xFF141422);
  static const Color darkCardLight = Color(0xFF1A1A2E);
  static const Color darkBorder = Color(0xFF252540);
  static const Color darkText1 = Color(0xFFEAEAF4);
  static const Color darkText2 = Color(0xFF7878A0);
  static const Color darkText3 = Color(0xFF45455E);

  // ── Light Palette ──
  static const Color lightBg = Color(0xFFF2F2F7);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E0EA);
  static const Color lightText1 = Color(0xFF1A1A2E);
  static const Color lightText2 = Color(0xFF6E6E8A);
  static const Color lightText3 = Color(0xFFA0A0B8);

  // ── Glass Card Decoration ──
  static BoxDecoration glassCard(
      {bool isDark = true, Color? glowColor, double radius = 20}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.white.withValues(alpha: 0.85),
      border: Border.all(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.04),
      ),
      boxShadow: isDark
          ? [
              if (glowColor != null)
                BoxShadow(
                    color: glowColor.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: -4),
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8)),
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2)),
            ]
          : [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4)),
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1)),
            ],
    );
  }

  // ── Glow Button Decoration ──
  static BoxDecoration glowButton({Color? color, double radius = 14}) {
    final c = color ?? accent;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: c.withValues(alpha: 0.15),
      border: Border.all(color: c.withValues(alpha: 0.3)),
      boxShadow: [
        BoxShadow(
            color: c.withValues(alpha: 0.15), blurRadius: 16, spreadRadius: -2),
        BoxShadow(color: c.withValues(alpha: 0.06), blurRadius: 4),
      ],
    );
  }

  // ── Dark Theme ──
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: accent,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accentAlt,
        surface: darkSurface,
        onSurface: darkText1,
      ),
      cardColor: darkCard,
      dividerColor: darkBorder,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: darkText1,
        displayColor: darkText1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: darkText1,
          letterSpacing: -0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: darkText2),
    );
  }

  // ── Light Theme ──
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: accentAlt,
        surface: lightSurface,
        onSurface: lightText1,
      ),
      cardColor: lightCard,
      dividerColor: lightBorder,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: lightText1,
        displayColor: lightText1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: lightText1,
          letterSpacing: -0.5,
        ),
      ),
      iconTheme: const IconThemeData(color: lightText2),
    );
  }
}
