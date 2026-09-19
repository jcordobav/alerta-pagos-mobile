import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  static const _icons = <IconData>[
    Icons.home_outlined,
    Icons.receipt_long_outlined,
    Icons.add_circle_outline,
    Icons.person_outline,
  ];
  static const _selectedIcons = <IconData>[
    Icons.home,
    Icons.receipt_long,
    Icons.add_circle,
    Icons.person,
  ];
  static const _labels = <String>[
    'Inicio',
    'Historial',
    'Agregar pago',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.outlineSoft)),
      ),
      child: Row(
        children: List.generate(_icons.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: Semantics(
              button: true,
              selected: isSelected,
              label: _labels[index],
              child: InkWell(
                key: ValueKey('bottom-nav-$index'),
                borderRadius: BorderRadius.circular(12),
                onTap: () => onDestinationSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 49,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isSelected ? _selectedIcons[index] : _icons[index],
                    size: 24,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
