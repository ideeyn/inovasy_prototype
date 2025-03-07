class IdeeynCurrencyString {
  /// convert from double/int to indonesian string, which uses [.] as thousand
  /// separator and [,] as decimal separator
  static String numberToStringIndonesian(double theNumber) {
    String thousandSep = "."; // thousand separator
    String decimalSep = ","; // decimal separator
    String finalText;
    if (theNumber == theNumber.floorToDouble()) {
      finalText = theNumber.toString().replaceAll('.', decimalSep);
    } else {
      finalText = theNumber.toStringAsFixed(2).replaceAll('.', decimalSep);
    }
    return finalText.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}$thousandSep',
    );
  }

  /// convert from indonesian string to double/int. indonesian number uses [.]
  /// as thousand separator and [,] as decimal separator
  static double stringToNumberIndonesian(String numericText) {
    String thousandSep = "."; // thousand separator
    String decimalSep = ","; // decimal separator
    return double.parse(
        numericText.replaceAll(thousandSep, '').replaceAll(decimalSep, '.'));
  }

  // --------------------------------------------------------------

  /// switch from english numeric string [,.] to indonesian [.,] or reverse
  static String stringSwitchEnglishOrIndonesian(String theNumber) {
    return theNumber
        .replaceAll('.', '|')
        .replaceAll(',', '.')
        .replaceAll('|', ',');
  }

  // --------------------------------------------------------------

  /// convert from double/int to indonesian string, which uses [,] as thousand
  /// separator and [.] as decimal separator
  static String numberToStringEnglish(double theNumber) {
    String thousandSep = ","; // thousand separator
    String decimalSep = "."; // decimal separator
    String finalText;
    if (theNumber == theNumber.floorToDouble()) {
      finalText = theNumber.toString().replaceAll('.', decimalSep);
    } else {
      finalText = theNumber.toStringAsFixed(2).replaceAll('.', decimalSep);
    }
    return finalText.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]}$thousandSep',
    );
  }

  /// convert from indonesian string to double/int. indonesian number uses [,]
  /// as thousand separator and [.] as decimal separator
  static double stringToNumberEnglish(String numericText) {
    String thousandSep = ","; // thousand separator
    String decimalSep = "."; // decimal separator
    return double.parse(
        numericText.replaceAll(thousandSep, '').replaceAll(decimalSep, '.'));
  }
}
