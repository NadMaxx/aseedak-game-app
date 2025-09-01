import 'package:flutter/services.dart';


extension GetSvgPath on String {
  String get toSvgPath => 'assets/svgs/$this.svg';
  String get toSvgNavPath => 'assets/svg/nav/$this.svg';
  String get toPngPath => 'assets/pngs/$this.png';
  String get toTextField => 'assets/pngs/fields/$this.png';
  String get toCartoon => 'assets/images/cartoons/$this.png';
  String get toBottomNavPath => 'assets/svg/bottomNav/$this.svg';
  String get toCoinsIconPath => 'assets/svg/icons/$this.svg';
  String get toAnimation => 'assets/animations/$this.json';

}

extension CapitalizeFirstWord on String {
  String capitalizeFirstWord() {
    if (trim().isEmpty) return this;

    final words = split(' ');
    words[0] = words[0][0].toUpperCase() + words[0].substring(1);
    return words.join(' ');
  }
}



class StringHelpers{
  static List<TextInputFormatter> decimalFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
    _DecimalTextInputFormatter(),
  ];
}
class _DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Allow only one decimal point
    if (newValue.text.contains('.') &&
        newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
      return oldValue;
    }

    return newValue;
  }
}

