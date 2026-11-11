import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vayro/app/theme/app_colors.dart';
import 'package:vayro/app/theme/app_theme.dart';

void main() {
  group('VAYRO Theme Initialization Tests', () {
    test('Dark theme enforces Midnight Black palette tokens', () {
      final theme = AppTheme.darkTheme;

      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundPrimary);
      expect(theme.primaryColor, AppColors.primaryAccent);
      expect(theme.colorScheme.secondary, AppColors.secondaryAccent);
      expect(theme.colorScheme.surface, AppColors.surface);
    });

    test('Theme contains configured card and button themes', () {
      final theme = AppTheme.darkTheme;

      expect(theme.cardTheme.color, AppColors.surface);
      expect(theme.cardTheme.elevation, 0.0);
      expect(theme.elevatedButtonTheme.style, isNotNull);
    });
  });
}

