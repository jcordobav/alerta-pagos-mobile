import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_header.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          AppHeader(title: title),
          Expanded(
            child: Center(
              child: Text(title, style: AppTextStyles.sectionTitle),
            ),
          ),
        ],
      ),
    );
  }
}
