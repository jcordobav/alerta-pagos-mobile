import '../models/manual_payment.dart';
import 'manual_payment_service.dart';

enum ManualPaymentScenario { success, error }

class MockManualPaymentService implements ManualPaymentService {
  const MockManualPaymentService({
    this.scenario = ManualPaymentScenario.success,
    this.latency = const Duration(milliseconds: 800),
  });

  final ManualPaymentScenario scenario;
  final Duration latency;

  @override
  Future<SavedManualPayment> savePayment(ManualPayment payment) async {
    await Future<void>.delayed(latency);

    if (scenario == ManualPaymentScenario.error) {
      throw const ManualPaymentException('No fue posible registrar el pago.');
    }

    return SavedManualPayment(
      id: 'manual-${DateTime.now().microsecondsSinceEpoch}',
      payment: payment,
    );
  }
}
