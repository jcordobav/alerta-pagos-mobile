import 'package:flutter/material.dart';

import '../../models/bill.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import '../../widgets/bill_card.dart';
import '../../widgets/home_filter_tabs.dart';

enum HomeFilter { pending, upcoming }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeFilter _selectedFilter = HomeFilter.pending;

  static const _bills = <Bill>[
    Bill(
      serviceName: 'Energía',
      amount: r'$72.300',
      dueDate: '22 Sep',
      status: BillStatus.pending,
      serviceType: ServiceType.energy,
      isUpcoming: true,
    ),
    Bill(
      serviceName: 'Internet',
      amount: r'$89.900',
      dueDate: '28 Sep',
      status: BillStatus.pending,
      serviceType: ServiceType.internet,
      isUpcoming: true,
    ),
    Bill(
      serviceName: 'Agua',
      amount: r'$58.200',
      dueDate: '02 Oct',
      status: BillStatus.pending,
      serviceType: ServiceType.water,
      isUpcoming: false,
    ),
  ];

  List<Bill> get _visibleBills => switch (_selectedFilter) {
    HomeFilter.pending =>
      _bills
          .where((bill) => bill.status == BillStatus.pending)
          .toList(growable: false),
    HomeFilter.upcoming =>
      _bills.where((bill) => bill.isUpcoming).toList(growable: false),
  };

  void _markAsPaid(Bill bill) {
    debugPrint('Marcar como pagado: ${bill.serviceName}');
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
}
