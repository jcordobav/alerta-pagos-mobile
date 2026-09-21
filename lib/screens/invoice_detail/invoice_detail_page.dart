import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import '../../widgets/invoice_action_button.dart';
import '../../widgets/invoice_info_card.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'Detalle de factura', showBackButton: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    InvoiceInfoCard(bill: bill),
                    const SizedBox(height: 16),
                    _OptionsCard(bill: bill),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionsCard extends StatelessWidget {
  const _OptionsCard({required this.bill});

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
          const Text('Opciones', style: AppTextStyles.optionsTitle),
          const SizedBox(height: 12),
          InvoiceActionButton(
            key: const ValueKey('invoice-action-pay'),
            label: 'Pagar',
            onPressed: () => debugPrint('Pagar ${bill.serviceName}'),
          ),
          const SizedBox(height: 12),
          InvoiceActionButton(
            key: const ValueKey('invoice-action-postpone'),
            label: 'Posponer',
            onPressed: () => debugPrint('Posponer ${bill.serviceName}'),
          ),
          const SizedBox(height: 12),
          InvoiceActionButton(
            key: const ValueKey('invoice-action-mark-paid'),
            label: 'Marcar como pagado',
            onPressed: () =>
                debugPrint('Marcar ${bill.serviceName} como pagado'),
          ),
        ],
      ),
    );
  }
}
