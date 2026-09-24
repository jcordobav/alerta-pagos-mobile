abstract final class ManualPaymentValidator {
  static const int serviceMinLength = 2;
  static const int serviceMaxLength = 40;
  static const int minAmount = 1000;
  static const int maxAmount = 50000000;
  static const int maxAmountDigits = 8;
  static const int notesMaxLength = 200;
  static const int maxYearsAhead = 2;

  static final RegExp _datePattern = RegExp(r'^(\d{2}) / (\d{2}) / (\d{4})$');

  static String? validateService(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el nombre del servicio';
    if (text.length < serviceMinLength) {
      return 'Debe tener al menos $serviceMinLength caracteres';
    }
    if (text.length > serviceMaxLength) {
      return 'Máximo $serviceMaxLength caracteres';
    }
    return null;
  }

  static String? validateAmount(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa el monto';
    final amount = parseAmount(text);
    if (amount == null) return 'Ingresa solo números';
    if (amount < minAmount) return r'El monto mínimo es $1.000';
    if (amount > maxAmount) return r'El monto máximo es $50.000.000';
    return null;
  }

  static String? validateDueDate(String? value, {required DateTime today}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingresa la fecha de vencimiento';
    if (!_datePattern.hasMatch(text)) return 'Usa el formato DD / MM / AAAA';
    final date = parseDate(text);
    if (date == null) return 'Ingresa una fecha válida';

    final start = DateTime(today.year, today.month, today.day);
    if (date.isBefore(start)) return 'La fecha no puede ser anterior a hoy';
    final limit = DateTime(start.year + maxYearsAhead, start.month, start.day);
    if (date.isAfter(limit)) {
      return 'La fecha no puede superar $maxYearsAhead años';
    }
    return null;
  }

  static String? validateNotes(String? value) {
    if ((value?.length ?? 0) > notesMaxLength) {
      return 'Máximo $notesMaxLength caracteres';
    }
    return null;
  }

  /// Convierte `48.000` o `48000` en `48000`.
  static int? parseAmount(String value) {
    final digits = value.replaceAll('.', '');
    if (digits.isEmpty || !RegExp(r'^\d+$').hasMatch(digits)) return null;
    return int.tryParse(digits);
  }

  /// Convierte una fecha en `DD / MM / AAAA`.
  static String formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)} / ${twoDigits(date.month)} / ${date.year}';
  }

  /// Convierte `DD / MM / AAAA` en una fecha real; `null` si no existe.
  static DateTime? parseDate(String value) {
    final match = _datePattern.firstMatch(value.trim());
    if (match == null) return null;
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    final date = DateTime(year, month, day);
    final isRealDate =
        date.year == year && date.month == month && date.day == day;
    return isRealDate ? date : null;
  }
}
