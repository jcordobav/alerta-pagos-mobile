import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum InvoiceActionVariant { primary, secondary, positive }

class InvoiceActionButton extends StatelessWidget {
  const InvoiceActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = InvoiceActionVariant.secondary,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final InvoiceActionVariant variant;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == InvoiceActionVariant.primary;
    final foreground = switch (variant) {
      InvoiceActionVariant.primary => Colors.white,
      InvoiceActionVariant.secondary => AppColors.textPrimary,
      InvoiceActionVariant.positive => AppColors.success,
    };
    final borderColor = switch (variant) {
      InvoiceActionVariant.primary => AppColors.primary,
      InvoiceActionVariant.secondary => AppColors.outlineSoft,
      InvoiceActionVariant.positive => AppColors.success,
    };

    final style = OutlinedButton.styleFrom(
      foregroundColor: foreground,
      backgroundColor: isPrimary ? AppColors.primary : AppColors.card,
      side: BorderSide(color: borderColor),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
    final labelWidget = Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: AppTextStyles.actionButton),
    );

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: icon == null
          ? OutlinedButton(
              onPressed: onPressed,
              style: style,
              child: labelWidget,
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: labelWidget,
              style: style,
            ),
    );
  }
}
