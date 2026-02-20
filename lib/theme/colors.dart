// lib/theme/colors.dart
// Single source of truth for all colour tokens.
// Swap these 5 lines to fully re-theme the portfolio.

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand palette ────────────────────────────────────────────────
  static const Color primary     = Color(0xFF6C63FF); // violet-blue
  static const Color primaryDark = Color(0xFF4C46C8);
  static const Color secondary   = Color(0xFF00D9C5); // teal accent
  static const Color accent      = Color(0xFFFF6584); // coral highlight

  // ── Backgrounds ──────────────────────────────────────────────────
  static const Color bgDark      = Color(0xFF0A0E1A);
  static const Color bgDark2     = Color(0xFF111526);
  static const Color bgLight     = Color(0xFFF4F6FB);
  static const Color surface     = Color(0xFF1A2035);
  static const Color surfaceLight= Color(0xFFFFFFFF);

  // ── Semantic ─────────────────────────────────────────────────────
  static const Color success     = Color(0xFF2ECC71);
  static const Color warning     = Color(0xFFF39C12);
  static const Color error       = Color(0xFFE74C3C);
  static const Color info        = Color(0xFF3498DB);

  // ── Text ─────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF0F2FF);
  static const Color textSecondary = Color(0xFF9BA3C5);
  static const Color textMuted     = Color(0xFF5A6282);
  static const Color textDark      = Color(0xFF1A1A2E);

  // ── Glass / overlay ──────────────────────────────────────────────
  static Color glass         = Colors.white.withOpacity(0.06);
  static Color glassBorder   = Colors.white.withOpacity(0.12);
  static Color glassLight    = Colors.white.withOpacity(0.85);

  // ── Gradient helpers ─────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0E1A), Color(0xFF1A1040), Color(0xFF0D2040)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E2745), Color(0xFF111830)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF9B59B6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondary, primary],
  );
}
