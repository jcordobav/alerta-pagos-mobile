import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/main_navigation_page.dart';
import 'theme/app_colors.dart';

void main() => runApp(const AlertaPagosApp());

class AlertaPagosApp extends StatelessWidget {
  const AlertaPagosApp({super.key, this.alarmSeconds = 60});

  final int alarmSeconds;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerta Pagos',
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'CO'),
      supportedLocales: const [Locale('es', 'CO')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
      ),
      home: MainNavigationPage(alarmSeconds: alarmSeconds),
    );
  }
}
