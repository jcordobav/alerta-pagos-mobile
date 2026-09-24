import 'package:flutter/material.dart';

import '../../models/paid_bill.dart';
import '../../services/payment_history_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import '../../widgets/paid_bill_card.dart';

enum _HistoryStatus { idle, loading, content, empty, error }

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.paymentHistoryService,
    required this.isActive,
  });

  final PaymentHistoryService paymentHistoryService;

  /// El historial se carga la primera vez que la pestaña se muestra.
  final bool isActive;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  _HistoryStatus _status = _HistoryStatus.idle;
  List<PaidBill> _paidBills = const [];

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _loadPaidBills();
  }

  @override
  void didUpdateWidget(HistoryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && _status == _HistoryStatus.idle) _loadPaidBills();
  }

  Future<void> _loadPaidBills() async {
    _status = _HistoryStatus.loading;
    if (mounted) setState(() {});

    try {
      final paidBills = await widget.paymentHistoryService.fetchPaidBills();
      if (!mounted) return;
      setState(() {
        _paidBills = paidBills;
        _status = paidBills.isEmpty
            ? _HistoryStatus.empty
            : _HistoryStatus.content;
      });
    } on PaymentHistoryException {
      if (!mounted) return;
      setState(() => _status = _HistoryStatus.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          const AppHeader(title: 'Historial'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: const Text(
                      'Facturas pagadas',
                      style: AppTextStyles.historySectionTitle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return switch (_status) {
      _HistoryStatus.idle => const SizedBox.shrink(),
      _HistoryStatus.loading => const Center(
        child: CircularProgressIndicator(
          key: ValueKey('history-loading'),
          semanticsLabel: 'Cargando historial',
        ),
      ),
      _HistoryStatus.content => ListView.separated(
        key: const ValueKey('history-list'),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: _paidBills.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final paidBill = _paidBills[index];
          return PaidBillCard(
            key: ValueKey('paid-bill-${paidBill.id}'),
            paidBill: paidBill,
          );
        },
      ),
      _HistoryStatus.empty => const _HistoryMessage(
        key: ValueKey('history-empty'),
        icon: Icons.receipt_long_outlined,
        title: 'Aún no tienes facturas pagadas',
        message: 'Cuando pagues una factura aparecerá en este historial.',
      ),
      _HistoryStatus.error => _HistoryMessage(
        key: const ValueKey('history-error'),
        icon: Icons.error_outline,
        iconColor: AppColors.error,
        title: 'No pudimos cargar tu historial',
        message: 'Revisa tu conexión e inténtalo de nuevo.',
        action: FilledButton(
          key: const ValueKey('history-retry'),
          onPressed: _loadPaidBills,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Reintentar', style: AppTextStyles.actionButton),
        ),
      ),
    };
  }
}

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.iconColor = AppColors.textSecondary,
    this.action,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 48, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(child: Icon(icon, size: 48, color: iconColor)),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.optionsTitle,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.stateMessage,
          ),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }
}
