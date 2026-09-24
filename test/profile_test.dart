import 'package:alerta_pagos/main.dart';
import 'package:alerta_pagos/models/user_profile.dart';
import 'package:alerta_pagos/screens/profile/profile_page.dart';
import 'package:alerta_pagos/services/mock_profile_service.dart';
import 'package:alerta_pagos/services/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingOnceService implements ProfileService {
  int calls = 0;

  @override
  Future<UserProfile> fetchProfile() async {
    calls++;
    if (calls == 1) throw const ProfileException('Fallo simulado');
    return const UserProfile(fullName: 'Alejandra Vela');
  }
}

Future<void> _pumpProfile(
  WidgetTester tester,
  ProfileService service, {
  Size size = const Size(390, 844),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ProfilePage(profileService: service, isActive: true),
      ),
    ),
  );
}

Future<void> _settleZeroLatency(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 1));
  await tester.pump();
}

void main() {
  group('MockProfileService', () {
    test('returns the profile for each scenario', () async {
      Future<UserProfile> fetch(ProfileScenario scenario) => MockProfileService(
        scenario: scenario,
        latency: Duration.zero,
      ).fetchProfile();

      final complete = await fetch(ProfileScenario.complete);
      expect(complete.fullName, 'Alejandra Vela');
      expect(complete.paymentMethod, isNotNull);

      final incomplete = await fetch(ProfileScenario.incomplete);
      expect(incomplete.username, isNull);
      expect(incomplete.email, isNull);
      expect(incomplete.paymentMethod, isNull);
    });

    test('throws ProfileException on the error scenario', () {
      const service = MockProfileService(
        scenario: ProfileScenario.error,
        latency: Duration.zero,
      );

      expect(service.fetchProfile(), throwsA(isA<ProfileException>()));
    });
  });

  test('formats username and payment method labels', () {
    const profile = UserProfile(fullName: 'A', username: 'Alejandra.vela');
    const credit = PaymentMethod(
      cardType: PaymentCardType.credit,
      brand: 'Visa',
      lastFourDigits: '9318',
    );
    const debit = PaymentMethod(
      cardType: PaymentCardType.debit,
      brand: 'Mastercard',
      lastFourDigits: '0042',
    );

    expect(profile.usernameLabel, '@Alejandra.vela');
    expect(const UserProfile(fullName: 'A').usernameLabel, isNull);
    expect(credit.title, 'Tarjeta de crédito');
    expect(credit.maskedNumber, 'Visa •••• 9318');
    expect(debit.title, 'Tarjeta de débito');
  });

  testWidgets('shows loading and then the complete profile', (tester) async {
    await _pumpProfile(tester, const MockProfileService());

    expect(find.byKey(const ValueKey('profile-loading')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();

    expect(find.byKey(const ValueKey('profile-loading')), findsNothing);
    expect(find.text('Alejandra Vela'), findsOneWidget);
    expect(find.text('@Alejandra.vela'), findsOneWidget);
    expect(find.text('avela@gmail.com'), findsOneWidget);
    expect(find.text('Método de pago asociado'), findsOneWidget);
    expect(find.text('Tarjeta de crédito'), findsOneWidget);
    expect(find.text('Visa •••• 9318'), findsOneWidget);
    expect(find.text('Bienvenida'), findsOneWidget);
  });

  testWidgets('hides missing optional data in an incomplete profile', (
    tester,
  ) async {
    await _pumpProfile(
      tester,
      const MockProfileService(
        scenario: ProfileScenario.incomplete,
        latency: Duration.zero,
      ),
    );
    await _settleZeroLatency(tester);

    expect(find.text('Juan Pérez'), findsOneWidget);
    expect(find.textContaining('@'), findsNothing);
    expect(find.text('Bienvenida'), findsNothing);
    expect(find.text('No tienes un método de pago asociado'), findsOneWidget);
  });

  testWidgets('shows the error state and recovers on retry', (tester) async {
    final service = _FailingOnceService();
    await _pumpProfile(tester, service);
    await tester.pump();

    expect(find.byKey(const ValueKey('profile-error')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile-retry')));
    await tester.pump();

    expect(service.calls, 2);
    expect(find.byKey(const ValueKey('profile-error')), findsNothing);
    expect(find.text('Alejandra Vela'), findsOneWidget);
  });

  testWidgets('long texts do not overflow on a narrow screen', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await _pumpProfile(
      tester,
      const MockProfileService(
        scenario: ProfileScenario.longText,
        latency: Duration.zero,
      ),
      size: const Size(320, 568),
    );
    await _settleZeroLatency(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Tarjeta de débito'), findsOneWidget);
  });

  testWidgets('bottom navigation opens the profile view', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const AlertaPagosApp());

    await tester.tap(find.byKey(const ValueKey('bottom-nav-3')));
    await tester.pumpAndSettle();

    expect(find.text('Perfil'), findsOneWidget);
    expect(find.text('Alejandra Vela'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-nav-0')));
    await tester.pumpAndSettle();
    expect(find.text('Próximos pagos'), findsOneWidget);
  });
}
