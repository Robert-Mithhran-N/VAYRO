import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/vayro_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Accent Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(color: AppColors.primaryAccent.withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Connected Group Travel',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Move as One.',
                style: AppTypography.displayLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'One group. One destination. Individual routes. Shared journey. Welcome to the foundation of connected travel coordination.',
                style: AppTypography.bodyLarge,
              ),
              const Spacer(),
              VayroButton(
                text: 'Launch Dashboard',
                isFullWidth: true,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go(AppConstants.routeHome),
              ),
              const SizedBox(height: AppSpacing.sm),
              VayroButton(
                text: 'Network Settings',
                variant: VayroButtonVariant.outline,
                isFullWidth: true,
                icon: Icons.settings_rounded,
                onPressed: () => context.push(AppConstants.routeSettings),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

