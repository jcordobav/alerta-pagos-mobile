import '../models/bill.dart';
import '../models/paid_bill.dart';

final demoPaymentHistory = <PaidBill>[
  PaidBill(
    id: 'internet-2026-08',
    serviceName: 'Internet',
    serviceType: ServiceType.internet,
    amount: r'$89.000',
    paidAt: DateTime(2026, 8, 14),
  ),
  PaidBill(
    id: 'energy-2026-07',
    serviceName: 'Energía',
    serviceType: ServiceType.energy,
    amount: r'$70.100',
    paidAt: DateTime(2026, 7, 21),
  ),
  PaidBill(
    id: 'gas-2026-09',
    serviceName: 'Gas',
    serviceType: ServiceType.gas,
    amount: r'$48.000',
    paidAt: DateTime(2026, 9, 1),
  ),
  PaidBill(
    id: 'water-2026-08',
    serviceName: 'Agua',
    serviceType: ServiceType.water,
    amount: r'$52.000',
    paidAt: DateTime(2026, 8, 20),
  ),
  PaidBill(
    id: 'water-2026-07',
    serviceName: 'Agua',
    serviceType: ServiceType.water,
    amount: r'$49.800',
    paidAt: DateTime(2026, 7, 20),
  ),
];

final longTextPaymentHistory = <PaidBill>[
  PaidBill(
    id: 'internet-long-2026-09',
    serviceName: 'Internet fibra óptica hogar + televisión y telefonía fija',
    serviceType: ServiceType.internet,
    amount: r'$1.249.990.000',
    paidAt: DateTime(2026, 9, 12),
  ),
  PaidBill(
    id: 'energy-long-2026-09',
    serviceName: 'Energía eléctrica conjunto residencial apartamento 1204',
    serviceType: ServiceType.energy,
    amount: r'$356.780',
    paidAt: DateTime(2026, 9, 3),
  ),
];
