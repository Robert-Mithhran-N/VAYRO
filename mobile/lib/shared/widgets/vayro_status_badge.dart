import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum VayroStatusLevel { success, warning, error, idle }

class VayroStatusBadge extends StatelessWidget {
  const VayroStatusBadge({
    super.key,
    required this.label,
    required this.level,
  });

  final String label;
  final VayroStatusLevel level;

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _resolveColor() {
    switch (level) {
      case VayroStatusLevel.success:
        return AppColors.statusSuccess;
      case VayroStatusLevel.warning:
        return AppColors.statusWarning;
      case VayroStatusLevel.error:
        return AppColors.statusError;
      case VayroStatusLevel.idle:
        return AppColors.textMuted;
    }
  }
}

