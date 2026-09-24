import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static const TextStyle appTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    height: 28 / 26,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle sectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle serviceName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    height: 22 / 16,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle amount = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle caption = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    height: 16 / 12,
  );
  static const TextStyle tab = TextStyle(
    fontSize: 14,
    height: 18 / 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle compactButton = TextStyle(
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle badge = TextStyle(
    fontSize: 11,
    height: 16 / 11,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle infoLabel = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    height: 19 / 14,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle infoValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    height: 19 / 14,
  );
  static const TextStyle optionsTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle actionButton = TextStyle(
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle historySectionTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    height: 27 / 20,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle paidAmount = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle paidDate = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    height: 18 / 13,
  );
  static const TextStyle stateMessage = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    height: 20 / 14,
  );
  static const TextStyle alarmTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 36,
    height: 49 / 36,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle alarmSupport = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 18,
    height: 24 / 18,
  );
  static const TextStyle alarmServiceName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    height: 38 / 28,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle alarmLabel = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle alarmAmount = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 30,
    height: 41 / 30,
    fontWeight: FontWeight.w600,
  );
}
