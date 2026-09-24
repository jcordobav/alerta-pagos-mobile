import 'package:flutter/material.dart';

import '../data/demo_bills.dart';
import '../services/alarm_timer_controller.dart';
import '../services/mock_payment_history_service.dart';
import '../services/payment_history_service.dart';
import '../widgets/app_bottom_navigation.dart';
import 'alarm/alarm_page.dart';
import 'history/history_page.dart';
import 'home/home_page.dart';
import 'placeholder_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({
    super.key,
    this.alarmSeconds = 60,
    this.paymentHistoryService = const MockPaymentHistoryService(),
  });

  final int alarmSeconds;
  final PaymentHistoryService paymentHistoryService;

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  bool _isAlarmVisible = false;
  late final AlarmTimerController _alarmTimerController;

  @override
  void initState() {
    super.initState();
    _alarmTimerController = AlarmTimerController(
      durationSeconds: widget.alarmSeconds,
      onAlarmTriggered: _showAlarm,
    )..start();
  }

  Future<void> _showAlarm() async {
    if (!mounted || _isAlarmVisible) return;

    _isAlarmVisible = true;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => AlarmPage(
          bill: energyBill,
          onDismiss: _closeAlarm,
          onResetTimer: _alarmTimerController.reset,
        ),
      ),
    );

    if (!mounted) return;
    _isAlarmVisible = false;
    _alarmTimerController.reset();
  }

  void _closeAlarm(BuildContext alarmContext) {
    _alarmTimerController.reset();
    Navigator.of(alarmContext).pop();
  }

  @override
  void dispose() {
    _alarmTimerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(alarmTimerController: _alarmTimerController),
      HistoryPage(
        paymentHistoryService: widget.paymentHistoryService,
        isActive: _selectedIndex == 1,
      ),
      const PlaceholderPage(title: 'Agregar pago'),
      const PlaceholderPage(title: 'Perfil'),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNavigation(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
      ),
    );
  }
}
