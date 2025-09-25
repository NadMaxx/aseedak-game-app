import 'dart:ui' as ui;

import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/customText.dart';
import '../../data/models/passModels/SuccessPassModel.dart';
import '../../data/utils/app_colors.dart';

class SuccessScreen extends StatelessWidget {
  static const String routeName = "/success_screen";
  final SuccessPassModel model;

  const SuccessScreen({
    super.key,
    required this.model,
  });
  // if(model.route == "pop"){
  // Navigator.pop(context);
  // return;
  // }
  // Navigator.pushNamedAndRemoveUntil(
  // context,
  // model.route,
  // (route) => false,
  // );
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 100.h,

            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20.0,
              ),
              child: SlantedButtonStack(text: model.buttonText, onPressed: (){
                if(model.route == "pop"){
                  Navigator.pop(context);
                  return;
                }
                if(model.removeRoute){
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    model.route,
                        (route) => false,
                  );
                  return;
                }
                Navigator.pushNamed(
                  context,
                  model.route,
                      // (route) => false,
                );
              })
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SizedBox(
            width: double.infinity,
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 120.h),
                CustomCircle(image: "check"),
                SizedBox(height: 20.h),
                CustomText(
                  text: model.title,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
                SizedBox(height: 10.h),
                CustomText(
                  text: model.message,
                  fontSize: 18.sp,
                  color: Colors.grey,
                  textAlign: TextAlign.center,
                  fontFamily: 'Kanit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
