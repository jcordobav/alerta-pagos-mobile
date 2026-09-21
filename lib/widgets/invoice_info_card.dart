import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'service_icon.dart';
import 'status_badge.dart';

class InvoiceInfoCard extends StatelessWidget {
  const InvoiceInfoCard({super.key, required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.outlineSoft),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ServiceIcon(serviceType: bill.serviceType, size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  bill.serviceName,
                  style: AppTextStyles.sectionTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Monto:', value: Text(bill.amount)),
          const Divider(height: 17, color: AppColors.outlineSoft),
          _InfoRow(label: 'Vence:', value: Text(bill.dueDate)),
          const Divider(height: 17, color: AppColors.outlineSoft),
          _InfoRow(
            label: 'Estado:',
            value: StatusBadge(status: bill.status),
          ),
          const Divider(height: 17, color: AppColors.outlineSoft),
          _InfoRow(label: 'Empresa:', value: Text(bill.companyName)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.infoLabel),
        const Spacer(),
        DefaultTextStyle(style: AppTextStyles.infoValue, child: value),
      ],
    );
  }
}
