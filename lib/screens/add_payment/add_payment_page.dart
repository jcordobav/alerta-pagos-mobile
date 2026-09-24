import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/manual_payment.dart';
import '../../services/manual_payment_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_header.dart';
import 'manual_payment_input_formatters.dart';
import 'manual_payment_validator.dart';

enum _SaveStatus { idle, saving, error }

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({
    super.key,
    required this.manualPaymentService,
    required this.onCancel,
    this.clock = DateTime.now,
  });

  final ManualPaymentService manualPaymentService;
  final VoidCallback onCancel;

  /// Fecha actual usada para validar el rango de vencimiento.
  final DateTime Function() clock;

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _dueDateFieldKey = GlobalKey<FormFieldState<String>>();
  final _serviceController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _notesController = TextEditingController();

  _SaveStatus _status = _SaveStatus.idle;

  List<TextEditingController> get _controllers => [
    _serviceController,
    _amountController,
    _dueDateController,
    _notesController,
  ];

  bool get _isSaving => _status == _SaveStatus.saving;

  bool get _isFormValid =>
      ManualPaymentValidator.validateService(_serviceController.text) == null &&
      ManualPaymentValidator.validateAmount(_amountController.text) == null &&
      _validateDueDate(_dueDateController.text) == null &&
      ManualPaymentValidator.validateNotes(_notesController.text) == null;

  @override
  void initState() {
    super.initState();
    for (final controller in _controllers) {
      controller.addListener(_onFormChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onFormChanged() => setState(() {});

  String? _validateDueDate(String? value) =>
      ManualPaymentValidator.validateDueDate(value, today: widget.clock());

  Future<void> _pickDueDate() async {
    final now = widget.clock();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      firstDate.year + ManualPaymentValidator.maxYearsAhead,
      firstDate.month,
      firstDate.day,
    );
    final selected = ManualPaymentValidator.parseDate(_dueDateController.text);
    final initialDate =
        selected == null ||
            selected.isBefore(firstDate) ||
            selected.isAfter(lastDate)
        ? firstDate
        : selected;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: firstDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Fecha de vencimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked == null || !mounted) return;

    _dueDateController.text = ManualPaymentValidator.formatDate(picked);
    _dueDateFieldKey.currentState?.validate();
  }

  Future<void> _save() async {
    if (!_isFormValid || _isSaving) return;
    FocusScope.of(context).unfocus();
    setState(() => _status = _SaveStatus.saving);

    final notes = _notesController.text.trim();
    final payment = ManualPayment(
      serviceName: _serviceController.text.trim(),
      amount: ManualPaymentValidator.parseAmount(_amountController.text)!,
      dueDate: ManualPaymentValidator.parseDate(_dueDateController.text)!,
      notes: notes.isEmpty ? null : notes,
    );

    try {
      final saved = await widget.manualPaymentService.savePayment(payment);
      if (!mounted) return;
      _formKey.currentState?.reset();
      setState(() => _status = _SaveStatus.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          key: const ValueKey('add-payment-success'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text(
            'Pago guardado: ${saved.payment.serviceName} '
            'por ${saved.payment.amountLabel}',
          ),
        ),
      );
    } on ManualPaymentException {
      if (!mounted) return;
      setState(() => _status = _SaveStatus.error);
    }
  }

  void _cancel() {
    _formKey.currentState?.reset();
    setState(() => _status = _SaveStatus.idle);
    FocusScope.of(context).unfocus();
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          const AppHeader(title: 'Agregar pago manual'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LabeledField(
                      label: 'Servicio',
                      child: TextFormField(
                        key: const ValueKey('add-payment-service'),
                        controller: _serviceController,
                        enabled: !_isSaving,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            ManualPaymentValidator.serviceMaxLength,
                          ),
                        ],
                        validator: ManualPaymentValidator.validateService,
                        style: AppTextStyles.infoValue,
                        decoration: _inputDecoration(
                          hint: 'Ej: Cable, Colegio, Gimnasio',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      label: 'Monto',
                      child: TextFormField(
                        key: const ValueKey('add-payment-amount'),
                        controller: _amountController,
                        enabled: !_isSaving,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        inputFormatters: const [
                          AmountInputFormatter(
                            maxDigits: ManualPaymentValidator.maxAmountDigits,
                          ),
                        ],
                        validator: ManualPaymentValidator.validateAmount,
                        style: AppTextStyles.currencyPrefix,
                        decoration: _inputDecoration(
                          prefix: const Padding(
                            padding: EdgeInsets.only(left: 14, right: 8),
                            child: Text(
                              r'$',
                              style: AppTextStyles.currencyPrefix,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      label: 'Fecha de vencimiento',
                      child: KeyedSubtree(
                        key: const ValueKey('add-payment-due-date'),
                        child: TextFormField(
                          key: _dueDateFieldKey,
                          controller: _dueDateController,
                          enabled: !_isSaving,
                          readOnly: true,
                          showCursor: false,
                          onTap: _pickDueDate,
                          autovalidateMode: AutovalidateMode.onUnfocus,
                          validator: _validateDueDate,
                          style: AppTextStyles.infoValue,
                          decoration: _inputDecoration(
                            hint: 'DD / MM / AAAA',
                            suffix: const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      label: 'Notas',
                      child: TextFormField(
                        key: const ValueKey('add-payment-notes'),
                        controller: _notesController,
                        enabled: !_isSaving,
                        minLines: 3,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            ManualPaymentValidator.notesMaxLength,
                          ),
                        ],
                        validator: ManualPaymentValidator.validateNotes,
                        style: AppTextStyles.infoValue,
                        decoration: _inputDecoration(
                          hint: 'Ej: Pago mensual correspondiente a...',
                          verticalPadding: 12,
                        ),
                      ),
                    ),
                    if (_status == _SaveStatus.error) ...[
                      const SizedBox(height: 16),
                      const _SaveErrorBanner(),
                    ],
                    const SizedBox(height: 16),
                    _SaveButton(
                      isSaving: _isSaving,
                      onPressed: _isFormValid && !_isSaving ? _save : null,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        key: const ValueKey('add-payment-cancel'),
                        onPressed: _isSaving ? null : _cancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          backgroundColor: AppColors.card,
                          side: const BorderSide(color: AppColors.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: AppTextStyles.formButton,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    Widget? prefix,
    Widget? suffix,
    double verticalPadding = 10,
  }) {
    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.formHint,
      isDense: true,
      filled: true,
      fillColor: AppColors.card,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: verticalPadding,
      ),
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(),
      suffixIcon: suffix,
      suffixIconConstraints: const BoxConstraints(minWidth: 44),
      errorMaxLines: 2,
      errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      border: border(AppColors.outline),
      enabledBorder: border(AppColors.outline),
      disabledBorder: border(AppColors.outlineSoft),
      focusedBorder: border(AppColors.primary, width: 1.5),
      errorBorder: border(AppColors.error),
      focusedErrorBorder: border(AppColors.error, width: 1.5),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(child: Text(label, style: AppTextStyles.infoLabel)),
        const SizedBox(height: 8),
        Semantics(label: label, child: child),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaving, required this.onPressed});

  final bool isSaving;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: FilledButton(
        key: const ValueKey('add-payment-save'),
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: isSaving
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.38),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isSaving
            ? const SizedBox(
                key: ValueKey('add-payment-saving'),
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                  semanticsLabel: 'Guardando pago',
                ),
              )
            : const Text('Guardar', style: AppTextStyles.formButton),
      ),
    );
  }
}

class _SaveErrorBanner extends StatelessWidget {
  const _SaveErrorBanner();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        key: const ValueKey('add-payment-error'),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No pudimos guardar el pago. Inténtalo de nuevo.',
                style: AppTextStyles.stateMessage.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
