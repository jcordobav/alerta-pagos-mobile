/// Borradores del formulario "Agregar pago manual" tal como los escribiría
/// el usuario, para probar el flujo completo.
class ManualPaymentDraft {
  const ManualPaymentDraft({
    required this.serviceName,
    required this.amount,
    this.dueDate,
    this.notes = '',
  });

  final String serviceName;
  final String amount;

  /// `null` cuando el usuario aún no ha elegido fecha en el calendario.
  final DateTime? dueDate;
  final String notes;
}

final validManualPaymentDraft = ManualPaymentDraft(
  serviceName: 'Gimnasio',
  amount: '85000',
  dueDate: DateTime(2026, 10, 15),
  notes: 'Pago mensual correspondiente a octubre',
);

const incompleteManualPaymentDraft = ManualPaymentDraft(
  serviceName: 'Colegio',
  amount: '',
);

final minimumAmountManualPaymentDraft = ManualPaymentDraft(
  serviceName: 'TV',
  amount: '1000',
  dueDate: DateTime(2026, 9, 23),
);

final maximumAmountManualPaymentDraft = ManualPaymentDraft(
  serviceName: 'Matrícula universidad',
  amount: '50000000',
  dueDate: DateTime(2028, 9, 23),
);

final longTextManualPaymentDraft = ManualPaymentDraft(
  serviceName: 'Cable, internet y telefonía del hogar',
  amount: '249990',
  dueDate: DateTime(2026, 11, 30),
  notes:
      'Pago mensual correspondiente al plan combinado de cable, internet de '
      'fibra óptica y telefonía fija, incluye el alquiler del decodificador '
      'adicional de la habitación principal y el cargo por servicio técnico.',
);
