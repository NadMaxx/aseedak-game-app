import 'dart:ui' as ui;

import 'package:aseedak/data/models/passModels/SuccessPassModel.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings_vm.dart';
import 'package:aseedak/view/success_screen/success_screen.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/customTextField.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/widgets/thick_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfileSettings extends StatelessWidget {
  static const String routeName = '/profileSettings';
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSettingsVm>(builder: (context, vm, child) {
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
                child: SlantedButtonStack(
                  text: "profile_settings_update".tr().toUpperCase(),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SuccessScreen.routeName,
                      arguments: SuccessPassModel(
                        title: "profile_settings_success_title".tr(),
                        buttonText: "profile_settings_success_btn".tr(),
                        route: "pop",
                        removeRoute: false,
                        message: "profile_settings_success_msg".tr(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: RotatedBox(
                    quarterTurns: 2,
                    child: SvgPicture.asset("back".toSvgPath)),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250.h,
                  width: double.infinity,
                  color: AppColors.secondary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomCircle(image: "person"),
                      SizedBox(height: 8.h),
                      ThickShadowText(
                        text: vm.currentUser.user!.firstName ?? "",
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                      CustomText(
                        text: vm.currentUser.user!.email ?? "",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: "Kanit",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40.h),
                      CustomTextField(
                        controller: vm.nameController,
                        prefix: "person",
                        hintText: "profile_settings_name".tr(),
                        keyboardType: TextInputType.name,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "profile_settings_name_required".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: vm.emailController,
                        prefix: "mail",
                        hintText: "profile_settings_email".tr(),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "profile_settings_email_required".tr();
                          }
                          if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
                          ).hasMatch(v)) {
                            return "profile_settings_email_invalid".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: vm.phoneController,
                        prefix: "phone",
                        hintText: "profile_settings_phone".tr(),
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "profile_settings_phone_required".tr();
                          }
                          if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v)) {
                            return "profile_settings_phone_invalid".tr();
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
