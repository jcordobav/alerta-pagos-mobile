class ManualPayment {
  const ManualPayment({
    required this.serviceName,
    required this.amount,
    required this.dueDate,
    this.notes,
  });

  final String serviceName;

  /// Monto en pesos, sin decimales.
  final int amount;
  final DateTime dueDate;
  final String? notes;

  /// Monto con separador de miles, por ejemplo `$48.000`.
  String get amountLabel {
    final digits = amount.toString();
    final buffer = StringBuffer(r'$');
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}

class SavedManualPayment {
  const SavedManualPayment({required this.id, required this.payment});

  final String id;
  final ManualPayment payment;
}
