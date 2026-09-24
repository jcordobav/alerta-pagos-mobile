import '../models/manual_payment.dart';

abstract interface class ManualPaymentService {
  Future<SavedManualPayment> savePayment(ManualPayment payment);
}

class ManualPaymentException implements Exception {
  const ManualPaymentException(this.message);

  final String message;

  @override
  String toString() => 'ManualPaymentException: $message';
}
