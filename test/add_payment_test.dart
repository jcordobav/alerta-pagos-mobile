import 'package:alerta_pagos/data/demo_manual_payments.dart';
import 'package:alerta_pagos/main.dart';
import 'package:alerta_pagos/models/manual_payment.dart';
import 'package:alerta_pagos/screens/add_payment/add_payment_page.dart';
import 'package:alerta_pagos/screens/add_payment/manual_payment_input_formatters.dart';
import 'package:alerta_pagos/screens/add_payment/manual_payment_validator.dart';
import 'package:alerta_pagos/services/manual_payment_service.dart';
import 'package:alerta_pagos/services/mock_manual_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final _today = DateTime(2026, 9, 23);

const _serviceField = ValueKey('add-payment-service');
const _amountField = ValueKey('add-payment-amount');
const _dueDateField = ValueKey('add-payment-due-date');
const _notesField = ValueKey('add-payment-notes');
const _saveButton = ValueKey('add-payment-save');

class _FailingOnceService implements ManualPaymentService {
  final List<ManualPayment> received = [];

  @override
  Future<SavedManualPayment> savePayment(ManualPayment payment) async {
    received.add(payment);
    if (received.length == 1) {
      throw const ManualPaymentException('Fallo simulado');
    }
    return SavedManualPayment(id: 'manual-retry', payment: payment);
  }
}

Future<void> _pumpPage(
  WidgetTester tester,
  ManualPaymentService service, {
  VoidCallback? onCancel,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es', 'CO'),
      supportedLocales: const [Locale('es', 'CO')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        body: AddPaymentPage(
          manualPaymentService: service,
          onCancel: onCancel ?? () {},
          clock: () => _today,
        ),
      ),
    ),
  );
}

Finder _inPicker(Finder finder) =>
    find.descendant(of: find.byType(DatePickerDialog), matching: finder);

MaterialLocalizations _pickerLocalizations(WidgetTester tester) =>
    MaterialLocalizations.of(tester.element(find.byType(DatePickerDialog)));

Future<void> _pickDate(WidgetTester tester, DateTime date) async {
  await tester.tap(find.byKey(_dueDateField));
  await tester.pumpAndSettle();
  final nextMonth = _pickerLocalizations(tester).nextMonthTooltip;
  final months = (date.year - _today.year) * 12 + date.month - _today.month;
  for (var i = 0; i < months; i++) {
    await tester.tap(find.byTooltip(nextMonth));
    await tester.pumpAndSettle();
  }
  await tester.tap(_inPicker(find.text('${date.day}')).hitTestable());
  await tester.tap(_inPicker(find.text('Aceptar')));
  await tester.pumpAndSettle();
}

Future<void> _fill(WidgetTester tester, ManualPaymentDraft draft) async {
  await tester.enterText(find.byKey(_serviceField), draft.serviceName);
  await tester.enterText(find.byKey(_amountField), draft.amount);
  final dueDate = draft.dueDate;
  if (dueDate != null) await _pickDate(tester, dueDate);
  await tester.enterText(find.byKey(_notesField), draft.notes);
  await tester.pump();
}

bool _isSaveEnabled(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(_saveButton)).onPressed != null;

String _fieldText(WidgetTester tester, Key key) => tester
    .widget<EditableText>(
      find.descendant(of: find.byKey(key), matching: find.byType(EditableText)),
    )
    .controller
    .text;

TextEditingValue _format(
  TextInputFormatter formatter,
  String old,
  String next,
) => formatter.formatEditUpdate(
  TextEditingValue(text: old),
  TextEditingValue(text: next),
);

void main() {
  group('ManualPaymentValidator', () {
    test('service is required and length limited', () {
      expect(ManualPaymentValidator.validateService('   '), isNotNull);
      expect(ManualPaymentValidator.validateService('A'), isNotNull);
      expect(ManualPaymentValidator.validateService('TV'), isNull);
      expect(ManualPaymentValidator.validateService('x' * 40), isNull);
      expect(ManualPaymentValidator.validateService('x' * 41), isNotNull);
    });

    test('amount must be numeric and within range', () {
      expect(ManualPaymentValidator.validateAmount(''), isNotNull);
      expect(ManualPaymentValidator.validateAmount('12a'), isNotNull);
      expect(ManualPaymentValidator.validateAmount('999'), isNotNull);
      expect(ManualPaymentValidator.validateAmount('1.000'), isNull);
      expect(ManualPaymentValidator.validateAmount('50.000.000'), isNull);
      expect(ManualPaymentValidator.validateAmount('50.000.001'), isNotNull);
      expect(ManualPaymentValidator.parseAmount('48.000'), 48000);
    });

    test('due date must be a real date between today and two years', () {
      String? validate(String value) =>
          ManualPaymentValidator.validateDueDate(value, today: _today);

      expect(validate(''), 'Ingresa la fecha de vencimiento');
      expect(validate('15 / 10'), 'Usa el formato DD / MM / AAAA');
      expect(validate('31 / 02 / 2027'), 'Ingresa una fecha válida');
      expect(
        validate('22 / 09 / 2026'),
        'La fecha no puede ser anterior a hoy',
      );
      expect(validate('23 / 09 / 2026'), isNull);
      expect(validate('23 / 09 / 2028'), isNull);
      expect(validate('24 / 09 / 2028'), 'La fecha no puede superar 2 años');
      expect(
        ManualPaymentValidator.parseDate('29 / 02 / 2028'),
        DateTime(2028, 2, 29),
      );
      expect(
        ManualPaymentValidator.formatDate(DateTime(2026, 10, 5)),
        '05 / 10 / 2026',
      );
    });

    test('notes are optional and limited to 200 characters', () {
      expect(ManualPaymentValidator.validateNotes(''), isNull);
      expect(ManualPaymentValidator.validateNotes('x' * 200), isNull);
      expect(ManualPaymentValidator.validateNotes('x' * 201), isNotNull);
    });
  });

  group('input formatters', () {
    test('amount keeps digits only and groups thousands', () {
      const formatter = AmountInputFormatter(maxDigits: 8);

      expect(_format(formatter, '', '0048000').text, '48.000');
      expect(_format(formatter, '', r'$1a2b3').text, '123');
      expect(_format(formatter, '12.345.678', '123456789').text, '12.345.678');
    });
  });

  group('MockManualPaymentService', () {
    final payment = ManualPayment(
      serviceName: 'Gimnasio',
      amount: 85000,
      dueDate: DateTime(2026, 10, 15),
    );

    test('returns the saved payment on success', () async {
      const service = MockManualPaymentService(latency: Duration.zero);

      final saved = await service.savePayment(payment);

      expect(saved.id, startsWith('manual-'));
      expect(saved.payment, same(payment));
      expect(saved.payment.amountLabel, r'$85.000');
    });

    test('throws ManualPaymentException on the error scenario', () {
      const service = MockManualPaymentService(
        scenario: ManualPaymentScenario.error,
        latency: Duration.zero,
      );

      expect(
        service.savePayment(payment),
        throwsA(isA<ManualPaymentException>()),
      );
    });
  });

  testWidgets('save stays disabled until the form is valid', (tester) async {
    await _pumpPage(tester, const MockManualPaymentService());

    expect(find.text('Ej: Cable, Colegio, Gimnasio'), findsOneWidget);
    expect(find.text('DD / MM / AAAA'), findsOneWidget);
    expect(_isSaveEnabled(tester), isFalse);

    await _fill(tester, incompleteManualPaymentDraft);
    expect(_isSaveEnabled(tester), isFalse);

    await _fill(tester, validManualPaymentDraft);
    expect(_fieldText(tester, _amountField), '85.000');
    expect(_fieldText(tester, _dueDateField), '15 / 10 / 2026');
    expect(_isSaveEnabled(tester), isTrue);
  });

  testWidgets('shows field errors after leaving an invalid field', (
    tester,
  ) async {
    await _pumpPage(tester, const MockManualPaymentService());

    await tester.enterText(find.byKey(_amountField), '500');
    await tester.tap(find.byKey(_dueDateField));
    await tester.pumpAndSettle();
    await tester.tap(_inPicker(find.text('Cancelar')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(_serviceField));
    await tester.pump();

    expect(find.text(r'El monto mínimo es $1.000'), findsOneWidget);
    expect(find.text('Ingresa la fecha de vencimiento'), findsOneWidget);
    expect(_isSaveEnabled(tester), isFalse);
  });

  testWidgets('saves with loading state, success message and reset', (
    tester,
  ) async {
    await _pumpPage(tester, const MockManualPaymentService());
    await _fill(tester, validManualPaymentDraft);

    await tester.tap(find.byKey(_saveButton));
    await tester.pump();

    expect(find.byKey(const ValueKey('add-payment-saving')), findsOneWidget);
    expect(_isSaveEnabled(tester), isFalse);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).enabled,
      isFalse,
    );

    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    expect(find.byKey(const ValueKey('add-payment-saving')), findsNothing);
    expect(find.text(r'Pago guardado: Gimnasio por $85.000'), findsOneWidget);
    expect(_fieldText(tester, _serviceField), isEmpty);
    expect(_fieldText(tester, _notesField), isEmpty);
    expect(_isSaveEnabled(tester), isFalse);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('keeps the data on save error and allows retry', (tester) async {
    final service = _FailingOnceService();
    await _pumpPage(tester, service);
    await _fill(tester, longTextManualPaymentDraft);

    await tester.tap(find.byKey(_saveButton));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const ValueKey('add-payment-error')), findsOneWidget);
    expect(
      _fieldText(tester, _serviceField),
      longTextManualPaymentDraft.serviceName,
    );
    expect(_isSaveEnabled(tester), isTrue);

    await tester.ensureVisible(find.byKey(_saveButton));
    await tester.tap(find.byKey(_saveButton));
    await tester.pump();
    await tester.pump();

    expect(service.received, hasLength(2));
    expect(service.received.last.amount, 249990);
    expect(service.received.last.dueDate, DateTime(2026, 11, 30));
    expect(
      service.received.last.notes,
      startsWith('Pago mensual correspondiente al plan combinado'),
    );
    expect(find.byKey(const ValueKey('add-payment-error')), findsNothing);
    expect(find.byKey(const ValueKey('add-payment-success')), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('saves boundary values and omits empty notes', (tester) async {
    final service = _FailingOnceService()
      ..received.add(
        ManualPayment(serviceName: '-', amount: 0, dueDate: DateTime(2000)),
      );
    await _pumpPage(tester, service);

    for (final draft in [
      minimumAmountManualPaymentDraft,
      maximumAmountManualPaymentDraft,
    ]) {
      await _fill(tester, draft);
      expect(_isSaveEnabled(tester), isTrue);
      await tester.tap(find.byKey(_saveButton));
      await tester.pump();
      await tester.pump();
    }

    expect(service.received[1].amount, 1000);
    expect(service.received[1].notes, isNull);
    expect(service.received[2].amount, 50000000);
    expect(service.received[2].dueDate, DateTime(2028, 9, 23));

    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets(
    'bottom navigation opens the form, spanish calendar and cancel returns home',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const AlertaPagosApp());

      await tester.tap(find.byKey(const ValueKey('bottom-nav-2')));
      await tester.pumpAndSettle();
      expect(find.text('Agregar pago manual'), findsOneWidget);

      await tester.tap(find.byKey(_dueDateField));
      await tester.pumpAndSettle();
      expect(_inPicker(find.text('Fecha de vencimiento')), findsOneWidget);
      final localizations = _pickerLocalizations(tester);
      expect(localizations, isA<MaterialLocalizationEs>());
      expect(
        _inPicker(find.byTooltip(localizations.nextMonthTooltip)),
        findsOneWidget,
      );
      expect(find.byTooltip('Next month'), findsNothing);
      await tester.tap(_inPicker(find.text('Cancelar')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(_serviceField), 'Cable');
      await tester.tap(find.byKey(const ValueKey('add-payment-cancel')));
      await tester.pumpAndSettle();
      expect(find.text('Próximos pagos'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('bottom-nav-2')));
      await tester.pumpAndSettle();
      expect(_fieldText(tester, _serviceField), isEmpty);
    },
  );
}
