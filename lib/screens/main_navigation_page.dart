import 'package:flutter/material.dart';

import '../widgets/app_bottom_navigation.dart';
import 'home/home_page.dart';
import 'placeholder_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const _pages = <Widget>[
    HomePage(),
    PlaceholderPage(title: 'Historial'),
    PlaceholderPage(title: 'Agregar pago'),
    PlaceholderPage(title: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNavigation(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
      ),
    );
  }
}
