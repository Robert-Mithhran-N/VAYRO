import 'package:flutter/material.dart';

/// Centralized brand color definitions for VAYRO.
/// Design System: Midnight Black, Deep Charcoal, Electric Violet & Electric Blue.
abstract final class AppColors {
  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF08090D);
  static const Color backgroundSecondary = Color(0xFF11131A);
  static const Color surface = Color(0xFF171A24);
  static const Color surfaceElevated = Color(0xFF1E2230);

  // Accents
  static const Color primaryAccent = Color(0xFF7957FF);   // Electric Violet
  static const Color secondaryAccent = Color(0xFF278BFF); // Electric Blue
  static const Color accentGradientStart = Color(0xFF7957FF);
  static const Color accentGradientEnd = Color(0xFF278BFF);

  // Typography
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFF9A9DAC);
  static const Color textMuted = Color(0xFF6B6E7D);

  // Borders & Dividers
  static const Color border = Color(0xFF292C39);
  static const Color borderSubtle = Color(0xFF1D202B);

  // Status Indicators
  static const Color statusSuccess = Color(0xFF00D26A);
  static const Color statusWarning = Color(0xFFFFB020);
  static const Color statusError = Color(0xFFF85149);
  static const Color statusInfo = Color(0xFF278BFF);

  // Overlay
  static const Color overlayDark = Color(0xCC08090D);
}

