import 'package:flutter/material.dart';

import '../models/bill.dart';
import '../theme/app_colors.dart';

class ServiceIcon extends StatelessWidget {
  const ServiceIcon({super.key, required this.serviceType, this.size = 32});

  final ServiceType serviceType;
  final double size;

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
      ServiceType.gas => (
        Icons.local_fire_department_outlined,
        AppColors.error,
        const Color(0xFFFFEBEE),
      ),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outline),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 3 / 7, color: color),
    );
  }
}
