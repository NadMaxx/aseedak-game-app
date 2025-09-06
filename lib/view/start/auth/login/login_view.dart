import 'dart:ui';

import 'package:aseedak/data/models/passModels/SuccessPassModel.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/sign_up/sign_up.dart';
import 'package:aseedak/view/success_screen/success_screen.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/customTextField.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/widgets/thick_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/blurred.dart';
import '../forgot_password/forgot_password.dart';
import '../forgot_password/forgot_password.dart';
import 'login_vm.dart';

class LoginView extends StatelessWidget {
  static const String routeName = '/login';
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginVm>(builder: (context, vm, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // 🔹 Background
            SizedBox(
              height: 500.h,
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    "smoke".toPngPath,
                    height: 420.h,
                    fit: BoxFit.fill,
                    color: AppColors.primary.withOpacity(0.7),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Positioned(
                    left: -100,
                    right: -100,
                    bottom: -180,
                    child: StretchedBlurredOval(
                      color: AppColors.primary,
                      sigma: 40,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Scrollable Form
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  bottom: 120.h, // leave space for bottom text
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100.h),
                    Image.asset(
                      "logo".toPngPath,
                      height: 120.h,
                      width: 250.w,
                    ),
                    SizedBox(height: 60.h),
                    ThickShadowText(
                      text: "LOGIN",
                      fontSize: 56.h,
                      fontWeight: FontWeight.w600,
                      shadowThickness: 4,
                    ),
                    SizedBox(height: 40.h),

                    // 🔹 Form
                    Form(
                      key: vm.formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: vm.emailController,
                            prefix: "mail",
                            hintText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Email is required";
                              }
                              if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
                              ).hasMatch(v)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          CustomTextField(
                            controller: vm.passwordController,
                            prefix: "lock",
                            hintText: "Password",
                            obscureText: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password is required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ForgotPassword.routeName);
                            },
                            child: Row(
                              children: [
                                CustomText(
                                  text: "Forgot Password? ",
                                  fontFamily: "Kanit",
                                  fontSize: 16.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                                CustomText(
                                  text: "Recover",
                                  fontFamily: "Kanit",
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.red,
                                  fontSize: 16.sp,
                                  color: AppColors.red,
                                  fontWeight: FontWeight.w300,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: SlantedButtonStack(
                                    text: 'LOGIN',
                                    onPressed: () {

                                      if (vm.formKey.currentState?.validate() ??
                                          false) {
                                        // TODO: handle login
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Stick to bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                bottom: true,
                minimum: EdgeInsets.only(bottom: 30.h),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, SignUpView.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Don’t have an account? ",
                        fontFamily: "Kanit",
                        fontSize: 16.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      CustomText(
                        text: "Register",
                        fontFamily: "Kanit",
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.red,
                        fontSize: 16.sp,
                        color: AppColors.red,
                        fontWeight: FontWeight.w300,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
