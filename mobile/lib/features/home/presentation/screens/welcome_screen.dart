import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/vayro_button.dart';
import '../../auth/presentation/providers/auth_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState is Authenticated;

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
                'One group. One destination. Individual routes. Shared journey. Welcome to the connected coordination platform for convoys.',
                style: AppTypography.bodyLarge,
              ),
              const Spacer(),
              if (isAuthenticated) ...[
                VayroButton(
                  text: 'Enter Dashboard',
                  isFullWidth: true,
                  icon: Icons.dashboard_rounded,
                  onPressed: () => context.go(AppConstants.routeHome),
                ),
              ] else ...[
                VayroButton(
                  text: 'Sign In to Convoy',
                  isFullWidth: true,
                  icon: Icons.login_rounded,
                  onPressed: () => context.push('/sign-in'),
                ),
                const SizedBox(height: AppSpacing.sm),
                VayroButton(
                  text: 'Create Traveler Account',
                  variant: VayroButtonVariant.secondary,
                  isFullWidth: true,
                  icon: Icons.person_add_rounded,
                  onPressed: () => context.push('/sign-up'),
                ),
                const SizedBox(height: AppSpacing.sm),
                VayroButton(
                  text: 'Explore as Guest',
                  variant: VayroButtonVariant.outline,
                  isFullWidth: true,
                  onPressed: () => context.go(AppConstants.routeHome),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.settings_outlined, size: 16.0),
                  label: const Text('Network Settings'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
                  onPressed: () => context.push(AppConstants.routeSettings),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
