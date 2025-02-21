import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      decimalDigits: decimalDigit,
      symbol: '',
    );
    return currencyFormatter.format(number);
  }

  static String removeGroupSeparator(String value) {
    return value.replaceAll('.', '');
  }
}
