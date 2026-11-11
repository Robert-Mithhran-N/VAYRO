import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/vayro_button.dart';
import '../../../../shared/widgets/vayro_card.dart';
import '../providers/health_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    final currentUrl = ref.read(envConfigProvider).apiBaseUrl;
    _urlController = TextEditingController(text: currentUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _applyUrl(String url) {
    _urlController.text = url;
    ref.read(envConfigProvider.notifier).setBaseUrl(url);
    ref.invalidate(backendHealthProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Target backend set to: $url'),
        backgroundColor: AppColors.surfaceElevated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUrl = ref.watch(envConfigProvider).apiBaseUrl;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Network & Environment'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Backend Host Endpoint', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Select an appropriate target host depending on your physical device or emulator environment.',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),

            // Quick presets
            Row(
              children: [
                Expanded(
                  child: VayroButton(
                    text: 'Android (10.0.2.2)',
                    variant: currentUrl.contains('10.0.2.2')
                        ? VayroButtonVariant.primary
                        : VayroButtonVariant.outline,
                    onPressed: () => _applyUrl(AppConstants.defaultEmulatorHost),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: VayroButton(
                    text: 'Desktop/Web (127.0.0.1)',
                    variant: currentUrl.contains('127.0.0.1')
                        ? VayroButtonVariant.primary
                        : VayroButtonVariant.outline,
                    onPressed: () => _applyUrl(AppConstants.defaultLocalhostHost),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Custom URL Input
            VayroCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Custom Endpoint Address', style: AppTypography.headlineMedium),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: _urlController,
                    style: AppTypography.code,
                    decoration: const InputDecoration(
                      labelText: 'API Base URL',
                      hintText: 'http://192.168.1.X:3000/api/v1',
                      prefixIcon: Icon(Icons.link_rounded),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  VayroButton(
                    text: 'Save and Apply',
                    icon: Icons.check_rounded,
                    isFullWidth: true,
                    onPressed: () => _applyUrl(_urlController.text.trim()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Physical Device Notice Card
            const VayroCard(
              backgroundColor: AppColors.backgroundSecondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.secondaryAccent, size: 20.0),
                      SizedBox(width: AppSpacing.sm),
                      Text('Physical Device Networking', style: AppTypography.labelLarge),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'When testing on a physical smartphone connected via USB or Wi-Fi, "localhost" points to the phone itself, NOT your development PC. '
                    'Enter your computer\'s local Wi-Fi IPv4 address (e.g., http://192.168.1.150:3000/api/v1) and ensure your firewall permits traffic on port 3000.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

