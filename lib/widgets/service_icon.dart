import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../theme/app_colors.dart';

class ServiceIcon extends StatelessWidget {
  const ServiceIcon({super.key, required this.serviceType});

  final ServiceType serviceType;

  @override
  Widget build(BuildContext context) {
    final (icon, color, background) = switch (serviceType) {
      ServiceType.energy => (
        Icons.bolt,
        AppColors.warning,
        AppColors.warningContainer,
      ),
      ServiceType.internet => (
        Icons.wifi,
        AppColors.primary,
        AppColors.primaryContainer,
      ),
      ServiceType.water => (
        Icons.water_drop_outlined,
        AppColors.primary,
        AppColors.primaryContainer,
      ),
    };

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outline),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: color),
    );
  }
}
