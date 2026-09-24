import '../models/paid_bill.dart';

abstract interface class PaymentHistoryService {
  /// Facturas pagadas, de la más reciente a la más antigua.
  Future<List<PaidBill>> fetchPaidBills();
}

class PaymentHistoryException implements Exception {
  const PaymentHistoryException(this.message);

  final String message;

  @override
  String toString() => 'PaymentHistoryException: $message';
}
