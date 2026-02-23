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

  // ── Dark Palette (Neumorphic) ──
  static const Color darkBg = Color(0xFF1E1E24);
  static const Color darkSurface = Color(0xFF23232A);
  static const Color darkCard = Color(0xFF26262E);
  static const Color darkCardLight = Color(0xFF2A2A32);
  static const Color darkBorder = Color(0xFF383842);
  static const Color darkText1 = Color(0xFFFFFFFF);
  static const Color darkText2 = Color(0xFFA6A6B2);
  static const Color darkText3 = Color(0xFF727280);

  // ── Light Palette (Neumorphic) ──
  static const Color lightBg = Color(0xFFE0E5EC);
  static const Color lightSurface = Color(0xFFE6EBF2);
  static const Color lightCard = Color(0xFFE0E5EC);
  static const Color lightBorder = Color(0xFFD1D9E6);
  static const Color lightText1 = Color(0xFF2D3748);
  static const Color lightText2 = Color(0xFF718096);
  static const Color lightText3 = Color(0xFFA0AEC0);

  // ── Neumorphic Card Decoration ──
  static BoxDecoration neoCard({
    bool isDark = true,
    double radius = 24,
    bool isInset = false,
  }) {
    final bgColor = isDark ? darkCard : lightCard;

    // For Neumorphism, we need a lighter shadow (top-left) and darker shadow (bottom-right)
    final lightShadow =
        isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final darkShadow = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : const Color(0xFFA3B1C6).withValues(alpha: 0.6);

    if (isInset) {
      // Inset illusion with uniform border to prevent borderRadius crash
      return BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFDDE3EB),
        border: Border.all(
          color: isDark ? const Color(0xFF16161C) : const Color(0xFFC7D0DC),
          width: 1.5,
        ),
      );
    }

    // Extruded (Pop-out) Neumorphic Effect
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: bgColor,
      boxShadow: [
        // Bottom-Right Dark Shadow
        BoxShadow(
          color: darkShadow,
          blurRadius: 16,
          offset: const Offset(8, 8),
        ),
        // Top-Left Light Highlight
        BoxShadow(
          color: lightShadow,
          blurRadius: 16,
          offset: const Offset(-8, -8),
        ),
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
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: darkText1,
        displayColor: darkText1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
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
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: lightText1,
        displayColor: lightText1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
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
