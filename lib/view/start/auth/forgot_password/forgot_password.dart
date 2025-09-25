import 'dart:developer';
import 'dart:ui' as ui;

import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/forgot_password/forgot_password_vm.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/customCirle.dart';
import '../../../../widgets/customTextField.dart';
import '../../../../widgets/custom_button.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = '/forgotPassword';

  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordVm>(
      builder: (context, vm, child) {
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
                  child: vm.isSending
                      ? const Center(child: CircularProgressIndicator())
                      : SlantedButtonStack(
                    text: "send_otp_code".tr(), // ✅ localized button
                    onPressed: () {
                      log("Send Reset Link Pressed ${vm.formKey.currentState!.validate() }");
                      if (vm.formKey.currentState!.validate() == true) {
                        vm.sendResetLink();
                      }
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
                  child: SvgPicture.asset("back".toSvgPath),
                ),
              ),
            ),

            body: Form(
              key: vm.formKey,
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  const CustomCircle(image: "lock"),
                  SizedBox(height: 16.h),

                  /// Title
                  CustomText(
                    text: "forgot_password_title".tr(),
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),

                  SizedBox(height: 16.h),

                  /// Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomText(
                      text: "forgot_password_message".tr(),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      textAlign: TextAlign.center,
                      fontFamily: "Kanit",
                    ),
                  ),

                  SizedBox(height: 50.h),

                  /// Email Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: CustomTextField(
                      controller: vm.emailController,
                      prefix: "mail",
                      hintText: "email".tr(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "email_required".tr();
                        }
                        if (!RegExp(
                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
                        ).hasMatch(v)) {
                          return "email_invalid".tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
