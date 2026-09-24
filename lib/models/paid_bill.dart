import 'bill.dart';

class PaidBill {
  const PaidBill({
    required this.id,
    required this.serviceName,
    required this.serviceType,
    required this.amount,
    required this.paidAt,
  });

  static const _monthLabels = <String>[
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  final String id;
  final String serviceName;
  final ServiceType serviceType;
  final String amount;
  final DateTime paidAt;

  /// Fecha corta de pago, por ejemplo `01 Sep`.
  String get paidDateLabel =>
      '${paidAt.day.toString().padLeft(2, '0')} '
      '${_monthLabels[paidAt.month - 1]}';
}
