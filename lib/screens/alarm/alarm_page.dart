import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/service_icon.dart';
import '../invoice_detail/invoice_detail_page.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({
    super.key,
    required this.bill,
    required this.onDismiss,
    required this.onResetTimer,
  });

  final Bill bill;
  final ValueChanged<BuildContext> onDismiss;
  final VoidCallback onResetTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 72, 24, 40),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.warningContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none,
                            color: AppColors.warning,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '¡Atención!',
                          style: AppTextStyles.alarmTitle,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tu pago vence pronto',
                          style: AppTextStyles.alarmSupport,
                        ),
                        const SizedBox(height: 24),
                        _AlarmBillCard(bill: bill),
                        const Spacer(),
                        _AlarmButton(
                          key: const ValueKey('alarm-postpone'),
                          label: 'Posponer 1 día',
                          icon: Icons.schedule,
                          onPressed: () => onDismiss(context),
                        ),
                        const SizedBox(height: 16),
                        _AlarmButton(
                          key: const ValueKey('alarm-paid'),
                          label: 'Ya pagué',
                          icon: Icons.check_circle_outline,
                          isPrimary: true,
                          onPressed: () => onDismiss(context),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          key: const ValueKey('alarm-view-detail'),
                          onPressed: () {
                            onResetTimer();
                            Navigator.of(context).push<void>(
                              MaterialPageRoute<void>(
                                builder: (_) => DetailPage(bill: bill),
                              ),
                            );
                          },
                          child: const Text('Ver detalle'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AlarmBillCard extends StatelessWidget {
  const _AlarmBillCard({required this.bill});

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 136,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.outlineSoft),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ServiceIcon(serviceType: bill.serviceType, size: 64),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.serviceName, style: AppTextStyles.alarmServiceName),
                const SizedBox(height: 8),
                const Text('Monto a pagar', style: AppTextStyles.alarmLabel),
                const SizedBox(height: 4),
                Text(bill.amount, style: AppTextStyles.alarmAmount),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlarmButton extends StatelessWidget {
  const _AlarmButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(label, style: AppTextStyles.actionButton),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: isPrimary ? Colors.white : AppColors.primary,
          backgroundColor: isPrimary ? AppColors.primary : Colors.white,
          side: BorderSide(
            color: isPrimary ? AppColors.primary : AppColors.outline,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
