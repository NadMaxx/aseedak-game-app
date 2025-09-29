import 'dart:ui' as ui;

import 'package:aseedak/data/models/passModels/SuccessPassModel.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/change_password/change_password_vm.dart';
import 'package:aseedak/view/start/auth/update_password/update_password_vm.dart';
import 'package:aseedak/view/success_screen/success_screen.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/customTextField.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class UpdatePassword extends StatelessWidget {
  static const String routeName = '/updatePassword';
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordVM>(builder: (context, vm, child) {
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
                child: vm.isLoading ? Center( child: CircularProgressIndicator(),) : SlantedButtonStack(
                  text: "update_password_save_btn".tr().toUpperCase(),
                  onPressed: () {
                    vm.changePassword();
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  CustomText(
                    text: "update_password_title".tr(),
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  CustomText(
                    text: "update_password_subtitle".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    fontFamily: "Kanit",
                  ),
                  SizedBox(height: 50.h),

                  // Current Password
                  CustomText(
                    text: "update_password_current".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    fontFamily: "Kanit",
                  ),
                  CustomTextField(
                    controller: vm.oldPassword,
                    prefix: "lock",
                    hintText: "update_password_hint".tr(),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "update_password_required".tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // New Password
                  CustomText(
                    text: "update_password_new".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    fontFamily: "Kanit",
                  ),
                  CustomTextField(
                    controller: vm.passwordController,
                    prefix: "lock",
                    hintText: "update_password_hint".tr(),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "update_password_required".tr();
                      }
                      if (v.length < 6) {
                        return "update_password_length".tr();
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),

                  // Confirm New Password
                  CustomText(
                    text: "update_password_confirm".tr(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    textAlign: TextAlign.center,
                    fontFamily: "Kanit",
                  ),
                  CustomTextField(
                    controller: vm.confirmPasswordController,
                    prefix: "lock",
                    hintText: "update_password_hint".tr(),
                    obscureText: true,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "update_password_required".tr();
                      }
                      if (v != vm.passwordController.text) {
                        return "update_password_mismatch".tr();
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
