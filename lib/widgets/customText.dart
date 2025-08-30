  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final double? fontSize;
  final Color? color;
  final Color? decorationColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final double? height;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.decorationColor,
    this.color,
    this.fontFamily,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.decoration,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        decoration: decoration ?? TextDecoration.none,
        decorationColor: decorationColor ?? Colors.white,
        fontSize: fontSize ?? 16.sp,
        color: color ?? AppColors.white,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing ?? 0.0,
        height: height,
        fontFamily: fontFamily ?? "Teko",
      ),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,

    );
  }
}