import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title = 'Alerta Pagos',
    this.showBackButton = false,
    this.onBack,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.outlineSoft)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: showBackButton
                  ? Material(
                      color: AppColors.outlineSoft,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        key: const ValueKey('detail-back-button'),
                        borderRadius: BorderRadius.circular(16),
                        onTap: onBack ?? () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.appTitle,
              ),
            ),
            const SizedBox(width: 32, height: 32),
          ],
        ),
      ),
    );
  }
}
