import 'package:flutter/material.dart';

import '../screens/home/home_page.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class HomeFilterTabs extends StatelessWidget {
  const HomeFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  final HomeFilter selectedFilter;
  final ValueChanged<HomeFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterTab(
            label: 'Pendientes',
            isSelected: selectedFilter == HomeFilter.pending,
            onTap: () => onChanged(HomeFilter.pending),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterTab(
            label: 'Próximos',
            isSelected: selectedFilter == HomeFilter.upcoming,
            onTap: () => onChanged(HomeFilter.upcoming),
          ),
        ),
      ],
    );
  }
}

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        key: ValueKey('home-filter-$label'),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: isSelected ? null : Border.all(color: AppColors.outline),
          ),
          child: Text(
            label,
            style: AppTextStyles.tab.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
