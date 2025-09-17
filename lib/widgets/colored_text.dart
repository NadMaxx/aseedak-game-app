import 'package:flutter/material.dart';

class ColoredText extends StatelessWidget {
  final List<TextSpan> textSpans;
  final TextStyle? defaultStyle;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const ColoredText({
    Key? key,
    required this.textSpans,
    this.defaultStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  }) : super(key: key);

  // Convenience constructor for simple two-color text
  ColoredText.twoColors({
    Key? key,
    required String firstText,
    required String secondText,
    required Color firstColor,
    required Color secondColor,
    this.defaultStyle,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.clip,
  }) : textSpans = [
    TextSpan(
      text: firstText,
      style: TextStyle(color: firstColor),
    ),
    TextSpan(
      text: secondText,
      style: TextStyle(color: secondColor),
    ),
  ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: Directionality.of(context), // ✅ THIS makes it follow locale (LTR/RTL)
      text: TextSpan(
        style: defaultStyle ?? DefaultTextStyle.of(context).style,
        children: textSpans,
      ),
    );
  }
}

// Helper class to make creating colored text spans easier
class ColoredTextSpan {
  static TextSpan create(String text, Color color, {TextStyle? style}) {
    return TextSpan(
      text: text,
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}
