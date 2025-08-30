import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/utils/app_colors.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? prefix;
  final bool readOnly;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Color? textColor;
  final int? maxLines;
  final double? fontSize;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefix,
    this.readOnly = false,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.textColor,
    this.maxLines = 1,
    this.fontSize,
    this.suffixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      maxLines: _obscure ? 1 : widget.maxLines,
      obscureText: _obscure,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      style: TextStyle(
        color: widget.textColor ?? AppColors.black,
        fontSize: widget.fontSize ?? 14.sp,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 12.sp,
        ),
        prefixIcon: widget.prefix == null
            ? null
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: SvgPicture.asset(
            widget.prefix!.toSvgPath,
            height: 20.h,
            width: 20.w,
            fit: BoxFit.scaleDown,
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: 40.h,
          minWidth: 40.w,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
            size: 20.sp,
          ),
          onPressed: _toggleObscure,
        )
            : widget.suffixIcon,
        filled: true,
        fillColor: Color(0xffF5F5F5),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Color(0xffE6E6E6),
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Color(0xffE6E6E6),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: Color(0xffE6E6E6),
            width: 1.5.w,
          ),
        ),
      ),
    );
  }
}
