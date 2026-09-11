import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

abstract final class Rupiah {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  static String format(int amount) {
    return _formatter.format(amount).trim();
  }

  static int parse(String input) {
    final clean = input.trim();
    if (clean.isEmpty) return 0;
    final isNegative = clean.startsWith('-');
    final digitsOnly = clean.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return 0;
    final parsed = int.tryParse(digitsOnly) ?? 0;
    return isNegative ? -parsed : parsed;
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  const ThousandsSeparatorInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return const TextEditingValue(text: '');

    final isNegative = newValue.text.startsWith('-');
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return TextEditingValue(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    }

    final clipped = digits.length > 13 ? digits.substring(0, 13) : digits;
    final parsed = int.tryParse(clipped) ?? 0;
    final formatted = '${isNegative ? '-' : ''}${Rupiah.format(parsed)}';

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
