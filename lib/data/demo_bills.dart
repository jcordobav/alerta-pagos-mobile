import '../models/bill.dart';

const energyBill = Bill(
  serviceName: 'Energía',
  amount: r'$72.300',
  dueDate: '22 Sep',
  status: BillStatus.pending,
  serviceType: ServiceType.energy,
  isUpcoming: true,
  companyName: 'ElectroBog',
);

const demoBills = <Bill>[
  energyBill,
  Bill(
    serviceName: 'Internet',
    amount: r'$89.900',
    dueDate: '28 Sep',
    status: BillStatus.pending,
    serviceType: ServiceType.internet,
    isUpcoming: true,
    companyName: 'ConectaNet',
  ),
  Bill(
    serviceName: 'Agua',
    amount: r'$58.200',
    dueDate: '02 Oct',
    status: BillStatus.pending,
    serviceType: ServiceType.water,
    isUpcoming: false,
    companyName: 'Acueducto',
  ),
];
