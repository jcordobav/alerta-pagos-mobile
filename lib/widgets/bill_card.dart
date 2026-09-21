import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'service_icon.dart';
import 'status_badge.dart';

class BillCard extends StatelessWidget {
  const BillCard({
    super.key,
    required this.bill,
    required this.onMarkPaid,
    this.onTap,
  });

  final Bill bill;
  final ValueChanged<Bill> onMarkPaid;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('bill-card-${bill.serviceName}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          height: 112,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outlineSoft),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    ServiceIcon(serviceType: bill.serviceType),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bill.serviceName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.serviceName,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Vence ${bill.dueDate}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(bill.amount, style: AppTextStyles.amount),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: Row(
                  children: [
                    StatusBadge(status: bill.status),
                    const Spacer(),
                    SizedBox(
                      width: 119,
                      height: 32,
                      child: FilledButton(
                        key: ValueKey('mark-paid-${bill.serviceName}'),
                        onPressed: () => onMarkPaid(bill),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Marcar pagado',
                            maxLines: 1,
                            style: AppTextStyles.compactButton,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
