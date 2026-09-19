import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final BillStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, foreground, background) = switch (status) {
      BillStatus.pending => (
        'Pendiente',
        AppColors.warning,
        AppColors.warningContainer,
      ),
      BillStatus.paid => ('Pagado', AppColors.success, const Color(0xFFE8F5E9)),
      BillStatus.overdue => (
        'Vencido',
        AppColors.error,
        const Color(0xFFFFEBEE),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          maxLines: 1,
          style: AppTextStyles.badge.copyWith(color: foreground),
        ),
      ),
    );
  }
}
