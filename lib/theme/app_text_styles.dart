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
}
