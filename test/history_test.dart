import 'package:alerta_pagos/main.dart';
import 'package:alerta_pagos/models/bill.dart';
import 'package:alerta_pagos/models/paid_bill.dart';
import 'package:alerta_pagos/screens/history/history_page.dart';
import 'package:alerta_pagos/services/mock_payment_history_service.dart';
import 'package:alerta_pagos/services/payment_history_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingOnceService implements PaymentHistoryService {
  int calls = 0;

  @override
  Future<List<PaidBill>> fetchPaidBills() async {
    calls++;
    if (calls == 1) {
      throw const PaymentHistoryException('Fallo simulado');
    }
    return [
      PaidBill(
        id: 'gas-retry',
        serviceName: 'Gas',
        serviceType: ServiceType.gas,
        amount: r'$48.000',
        paidAt: DateTime(2026, 9, 1),
      ),
    ];
  }
}

Future<void> _pumpHistory(
  WidgetTester tester,
  PaymentHistoryService service, {
  Size size = const Size(390, 844),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: HistoryPage(paymentHistoryService: service, isActive: true),
      ),
    ),
  );
}

void main() {
  group('MockPaymentHistoryService', () {
    test('returns paid bills sorted from most recent to oldest', () async {
      const service = MockPaymentHistoryService(latency: Duration.zero);

      final bills = await service.fetchPaidBills();

      expect(bills.map((bill) => bill.id).take(3), [
        'gas-2026-09',
        'water-2026-08',
        'internet-2026-08',
      ]);
      for (var i = 1; i < bills.length; i++) {
        expect(bills[i - 1].paidAt.isAfter(bills[i].paidAt), isTrue);
      }
    });

    test('returns an empty list for the empty scenario', () async {
      const service = MockPaymentHistoryService(
        scenario: PaymentHistoryScenario.empty,
        latency: Duration.zero,
      );

      expect(await service.fetchPaidBills(), isEmpty);
    });

    test('throws PaymentHistoryException for the error scenario', () {
      const service = MockPaymentHistoryService(
        scenario: PaymentHistoryScenario.error,
        latency: Duration.zero,
      );

      expect(service.fetchPaidBills(), throwsA(isA<PaymentHistoryException>()));
    });
  });

  test('paidDateLabel formats day and spanish month abbreviation', () {
    PaidBill paidOn(DateTime date) => PaidBill(
      id: 'id',
      serviceName: 'Agua',
      serviceType: ServiceType.water,
      amount: r'$1',
      paidAt: date,
    );

    expect(paidOn(DateTime(2026, 9, 1)).paidDateLabel, '01 Sep');
    expect(paidOn(DateTime(2026, 8, 14)).paidDateLabel, '14 Ago');
    expect(paidOn(DateTime(2026, 1, 31)).paidDateLabel, '31 Ene');
  });

  testWidgets('shows loading and then the paid bills', (tester) async {
    await _pumpHistory(tester, const MockPaymentHistoryService());

    expect(find.byKey(const ValueKey('history-loading')), findsOneWidget);
    expect(find.text('Facturas pagadas'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    expect(find.byKey(const ValueKey('history-loading')), findsNothing);
    expect(find.text('Gas'), findsOneWidget);
    expect(find.text(r'$48.000'), findsOneWidget);
    expect(find.text('pagado 01 Sep'), findsOneWidget);
    expect(find.text('pagado 14 Ago'), findsOneWidget);
    expect(find.text('Pagado'), findsWidgets);
  });

  testWidgets('shows the empty state', (tester) async {
    await _pumpHistory(
      tester,
      const MockPaymentHistoryService(
        scenario: PaymentHistoryScenario.empty,
        latency: Duration.zero,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();

    expect(find.byKey(const ValueKey('history-empty')), findsOneWidget);
    expect(find.text('Aún no tienes facturas pagadas'), findsOneWidget);
  });

  testWidgets('shows the error state and recovers on retry', (tester) async {
    final service = _FailingOnceService();
    await _pumpHistory(tester, service);
    await tester.pump();

    expect(find.byKey(const ValueKey('history-error')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('history-retry')));
    await tester.pump();

    expect(service.calls, 2);
    expect(find.byKey(const ValueKey('history-error')), findsNothing);
    expect(find.byKey(const ValueKey('paid-bill-gas-retry')), findsOneWidget);
  });

  testWidgets('long texts do not overflow on a narrow screen', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpHistory(
      tester,
      const MockPaymentHistoryService(
        scenario: PaymentHistoryScenario.longText,
        latency: Duration.zero,
      ),
      size: const Size(320, 568),
    );
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey('paid-bill-internet-long-2026-09')),
      findsOneWidget,
    );
  });

  testWidgets('bottom navigation opens the history view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp());

    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();

    expect(find.text('Facturas pagadas'), findsOneWidget);
    expect(find.byKey(const ValueKey('paid-bill-gas-2026-09')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pumpAndSettle();
    expect(find.text('Próximos pagos'), findsOneWidget);
  });
}
