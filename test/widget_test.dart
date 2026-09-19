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
    expect(find.text('Agregar pago'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-3')));
    await tester.pumpAndSettle();
    expect(find.text('Perfil'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pumpAndSettle();
    expect(find.text('Próximos pagos'), findsOneWidget);
  });
}
