import '../data/demo_payment_history.dart';
import '../models/paid_bill.dart';
import 'payment_history_service.dart';

enum PaymentHistoryScenario { content, empty, error, longText }

class MockPaymentHistoryService implements PaymentHistoryService {
  const MockPaymentHistoryService({
    this.scenario = PaymentHistoryScenario.content,
    this.latency = const Duration(milliseconds: 600),
  });

  final PaymentHistoryScenario scenario;
  final Duration latency;

  @override
  Future<List<PaidBill>> fetchPaidBills() async {
    await Future<void>.delayed(latency);

    final bills = switch (scenario) {
      PaymentHistoryScenario.content => demoPaymentHistory,
      PaymentHistoryScenario.empty => const <PaidBill>[],
      PaymentHistoryScenario.longText => longTextPaymentHistory,
      PaymentHistoryScenario.error => throw const PaymentHistoryException(
        'No fue posible obtener el historial de pagos.',
      ),
    };

    return [...bills]..sort((a, b) => b.paidAt.compareTo(a.paidAt));
  }
}
