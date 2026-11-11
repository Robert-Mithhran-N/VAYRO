import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_typography.dart';

enum VayroButtonVariant { primary, secondary, outline }

class VayroButton extends StatelessWidget {
  const VayroButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = VayroButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final VayroButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveChild = isLoading
        ? const SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.0),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(text, style: AppTypography.labelLarge),
            ],
          );

    final style = _resolveStyle();

    final button = variant == VayroButtonVariant.outline
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: effectiveChild,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: effectiveChild,
          );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  ButtonStyle _resolveStyle() {
    switch (variant) {
      case VayroButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primaryAccent.withValues(alpha: 0.5),
        );
      case VayroButtonVariant.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceElevated,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
        );
      case VayroButtonVariant.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.0),
        );
    }
  }
}

