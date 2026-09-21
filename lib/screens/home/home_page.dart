import 'package:flutter/material.dart';

import '../../data/demo_bills.dart';
import '../../models/bill.dart';
import '../../services/alarm_timer_controller.dart';
import '../invoice_detail/invoice_detail_page.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bill_card.dart';
import '../../widgets/home_filter_tabs.dart';

enum HomeFilter { pending, upcoming }

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.alarmTimerController});

  final AlarmTimerController alarmTimerController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeFilter _selectedFilter = HomeFilter.pending;

  List<Bill> get _visibleBills => switch (_selectedFilter) {
    HomeFilter.pending =>
      demoBills
          .where((bill) => bill.status == BillStatus.pending)
          .toList(growable: false),
    HomeFilter.upcoming =>
      demoBills.where((bill) => bill.isUpcoming).toList(growable: false),
  };

  void _markAsPaid(Bill bill) {
    debugPrint('Marcar como pagado: ${bill.serviceName}');
  }

  void _openDetail(Bill bill) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => DetailPage(bill: bill)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Próximos pagos',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: 4),
                  const SizedBox(height: 16),
                  HomeFilterTabs(
                    selectedFilter: _selectedFilter,
                    onChanged: (filter) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      key: ValueKey(_selectedFilter),
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: _visibleBills.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final bill = _visibleBills[index];
                        return BillCard(
                          key: ValueKey(bill.serviceName),
                          bill: bill,
                          onMarkPaid: _markAsPaid,
                          onTap: () => _openDetail(bill),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
