import 'package:alerta_pagos/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('filters pending and upcoming bills on the same HomePage', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const AlertaPagosApp());

    expect(find.text('Energía'), findsOneWidget);
    expect(find.text('Internet'), findsOneWidget);
    expect(find.text('Agua'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('home-filter-Próximos')));
    await tester.pumpAndSettle();

    expect(find.text('Energía'), findsOneWidget);
    expect(find.text('Internet'), findsOneWidget);
    expect(find.text('Agua'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('home-filter-Pendientes')));
    await tester.pumpAndSettle();
    expect(find.text('Agua'), findsOneWidget);
  });

  testWidgets('bottom navigation opens placeholders and returns home', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 1;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const AlertaPagosApp());

    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pumpAndSettle();
    expect(find.text('Historial'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-2')));
    await tester.pumpAndSettle();
    expect(find.text('Agregar pago manual'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-3')));
    await tester.pumpAndSettle();
    expect(find.text('Perfil'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pumpAndSettle();
    expect(find.text('Próximos pagos'), findsOneWidget);
  });

  testWidgets('bill cards open their dynamic detail and back returns home', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp());

    final cases = <String, List<String>>{
      'Energía': [r'$72.300', '22 Sep', 'ElectroBog'],
      'Internet': [r'$89.900', '28 Sep', 'ConectaNet'],
      'Agua': [r'$58.200', '02 Oct', 'Acueducto'],
    };

    for (final entry in cases.entries) {
      await tester.tap(find.byKey(ValueKey('bill-card-${entry.key}')));
      await tester.pumpAndSettle();

      expect(find.text(entry.key), findsOneWidget);
      expect(find.text(entry.value[0]), findsOneWidget);
      expect(find.text(entry.value[1]), findsOneWidget);
      expect(find.text(entry.value[2]), findsOneWidget);
      expect(find.text('Detalle de factura'), findsOneWidget);
      expect(find.text('Opciones'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('detail-back-button')));
      await tester.pumpAndSettle();
      expect(find.text('Próximos pagos'), findsOneWidget);
    }
  });

  testWidgets('mark paid button does not open invoice detail', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp());

    await tester.tap(find.byKey(const ValueKey('mark-paid-Energía')));
    await tester.pumpAndSettle();

    expect(find.text('Próximos pagos'), findsOneWidget);
    expect(find.text('Opciones'), findsNothing);
    expect(find.byKey(const ValueKey('detail-back-button')), findsNothing);
  });

  testWidgets('alarm countdown triggers one page and postpone resets it', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp(alarmSeconds: 2));

    expect(find.text('Próxima alarma en 00:02'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Próxima alarma en 00:01'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('¡Atención!'), findsOneWidget);
    expect(find.text('Energía'), findsWidgets);
    expect(find.text(r'$72.300'), findsWidgets);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('¡Atención!'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('alarm-postpone')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('¡Atención!'), findsNothing);
    expect(find.text('Próxima alarma en 00:02'), findsOneWidget);
  });

  testWidgets('alarm opens dynamic detail and returns to the alarm', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp(alarmSeconds: 2));

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('alarm-view-detail')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Detalle de factura'), findsOneWidget);
    expect(find.text('ElectroBog'), findsOneWidget);
    expect(find.text(r'$72.300'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('detail-back-button')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('¡Atención!'), findsOneWidget);
  });

  testWidgets('changing bottom tab does not restart the countdown', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp(alarmSeconds: 4));

    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('bottom-nav-1')));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pump();

    expect(find.text('Próxima alarma en 00:02'), findsOneWidget);
  });
}
