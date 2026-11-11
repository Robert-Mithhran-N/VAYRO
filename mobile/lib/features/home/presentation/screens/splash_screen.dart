import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.go(AppConstants.routeWelcome);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand Logo Placeholder
            Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withValues(alpha: 0.3),
                    blurRadius: 24.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              AppConstants.appName,
              style: AppTypography.displayLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              AppConstants.appTagline,
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

