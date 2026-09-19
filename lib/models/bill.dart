enum ServiceType { energy, internet, water }

enum BillStatus { pending, paid, overdue }

class Bill {
  const Bill({
    required this.serviceName,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.serviceType,
    required this.isUpcoming,
  });

  final String serviceName;
  final String amount;
  final String dueDate;
  final BillStatus status;
  final ServiceType serviceType;
  final bool isUpcoming;
}
