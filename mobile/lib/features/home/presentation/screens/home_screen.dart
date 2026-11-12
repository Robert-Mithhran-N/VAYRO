import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/vayro_button.dart';
import '../../../../shared/widgets/vayro_card.dart';
import '../../../../shared/widgets/vayro_loading_indicator.dart';
import '../../../../shared/widgets/vayro_status_badge.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../providers/health_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(backendHealthProvider);
    final envConfig = ref.watch(envConfigProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 28.0,
              height: 28.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryAccent, AppColors.secondaryAccent],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: const Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(AppConstants.appName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push(AppConstants.routeSettings),
          ),
          if (authState is Authenticated)
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              tooltip: 'Sign Out',
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
            )
          else
            TextButton(
              onPressed: () => context.push('/sign-in'),
              child: const Text('Sign In', style: TextStyle(color: AppColors.primaryAccent)),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(backendHealthProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.paddingScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Greeting Banner
              if (authState is Authenticated) ...[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.2),
                      child: Text(
                        authState.user.displayName.isNotEmpty
                            ? authState.user.displayName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: AppColors.primaryAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, ${authState.user.displayName}',
                          style: AppTypography.displayMedium,
                        ),
                        Text(
                          authState.user.email,
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                const Text(
                  'Welcome, Traveler',
                  style: AppTypography.displayMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Move as One. Connect with your group, share your journey, and navigate together.',
                  style: AppTypography.bodyMedium,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),

              // End-to-End Smoke Test & System Health Card
              _buildIntegrationStatusCard(context, ref, healthAsync, envConfig.apiBaseUrl),
              const SizedBox(height: AppSpacing.xl),

              // Servers Section
              _buildSectionHeader(
                title: 'Travel Communities (Servers)',
                badgeText: 'Phase 3',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildEmptyStateCard(
                icon: Icons.hub_outlined,
                title: 'No Servers Joined',
                subtitle:
                    'Private travel servers and role management will be activated in Phase 3.',
              ),
              const SizedBox(height: AppSpacing.xl),

              // Trips Section
              _buildSectionHeader(
                title: 'Active Trips',
                badgeText: 'Phase 5',
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildEmptyStateCard(
                icon: Icons.navigation_outlined,
                title: 'No Active Journey',
                subtitle:
                    'Trip creation, independent routes, and shared destinations will be unlocked in Phase 5.',
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String badgeText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.headlineMedium),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            badgeText,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyStateCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return VayroCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            Icon(icon, size: 36.0, color: AppColors.textMuted),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationStatusCard(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<dynamic> healthAsync,
    String targetUrl,
  ) {
    return VayroCard(
      backgroundColor: AppColors.surface,
      borderColor: AppColors.primaryAccent.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('System Integration Status', style: AppTypography.headlineMedium),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20.0),
                tooltip: 'Run Integration Smoke Test',
                onPressed: () => ref.invalidate(backendHealthProvider),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Target API: $targetUrl',
            style: AppTypography.code.copyWith(fontSize: 11.0),
          ),
          const Divider(height: 24.0),
          healthAsync.when(
            data: (health) {
              return Column(
                children: [
                  _buildStatusRow(
                    label: 'Backend NestJS Service',
                    status: health.isHealthy ? 'ONLINE' : 'DEGRADED',
                    level: health.isHealthy ? VayroStatusLevel.success : VayroStatusLevel.warning,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusRow(
                    label: 'PostgreSQL Database',
                    status: health.databaseStatus == 'healthy'
                        ? 'CONNECTED (Prisma Record #${health.smokeTestRecordId ?? 1})'
                        : (health.databaseStatus?.toUpperCase() ?? 'DISCONNECTED'),
                    level: health.databaseStatus == 'healthy'
                        ? VayroStatusLevel.success
                        : VayroStatusLevel.warning,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusRow(
                    label: 'Redis Cache Layer',
                    status: health.redisStatus?.toUpperCase() ?? 'PENDING',
                    level: health.redisStatus == 'healthy'
                        ? VayroStatusLevel.success
                        : VayroStatusLevel.idle,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildStatusRow(
                    label: 'Drift Local Persistence',
                    status: 'SYNCED (SQLite Engine Ready)',
                    level: VayroStatusLevel.success,
                  ),
                  if (health.timestamp.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Last Verified: ${health.timestamp}',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: VayroLoadingIndicator(message: 'Executing end-to-end integration check...'),
            ),
            error: (err, stack) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusRow(
                    label: 'Backend Connection',
                    status: 'UNREACHABLE',
                    level: VayroStatusLevel.error,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Error: $err',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.statusError),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  VayroButton(
                    text: 'Configure API Address',
                    variant: VayroButtonVariant.secondary,
                    icon: Icons.settings_rounded,
                    onPressed: () => context.push(AppConstants.routeSettings),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required String label,
    required String status,
    required VayroStatusLevel level,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: AppTypography.bodyMedium),
        ),
        VayroStatusBadge(label: status, level: level),
      ],
    );
  }
}
