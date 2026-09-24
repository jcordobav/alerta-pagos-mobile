import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../models/paid_bill.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'service_icon.dart';
import 'status_badge.dart';

class PaidBillCard extends StatelessWidget {
  const PaidBillCard({super.key, required this.paidBill});

  final PaidBill paidBill;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.outlineSoft),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: ServiceIcon(serviceType: paidBill.serviceType, size: 48),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    paidBill.serviceName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.serviceName,
                  ),
                  const SizedBox(height: 4),
                  Text(paidBill.amount, style: AppTextStyles.paidAmount),
                  const SizedBox(height: 4),
                  Text(
                    'pagado ${paidBill.paidDateLabel}',
                    style: AppTextStyles.paidDate,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const StatusBadge(status: BillStatus.paid),
          ],
        ),
      ),
    );
  }
}
