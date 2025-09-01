import 'dart:developer';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:aseedak/view/start/auth/sign_up/sign_up_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../data/utils/app_colors.dart';
import '../../../../data/utils/app_constants.dart';
import '../../../../widgets/blurred.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/customTextField.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/thick_text.dart';

class SignUpView extends StatelessWidget {
  static const String routeName = '/sign_up';
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpVm>(
      builder: (context, vm, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true, // ✅ allow screen to adjust on keyboard
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

              // 🔹 Scrollable Content
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    bottom: 40.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 80.h),
                      Image.asset(
                        "logo".toPngPath,
                        height: 120.h,
                        width: 250.w,
                      ),
                      SizedBox(height: 50.h),
                      ThickShadowText(
                        text: "REGISTER",
                        fontSize: 56.h,
                        fontWeight: FontWeight.w600,
                        shadowThickness: 4,
                      ),
                      SizedBox(height: 30.h),

                      // 🔹 Form
                      Form(
                        key: vm.formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: vm.nameController,
                              prefix: "person",
                              hintText: "Full Name",
                              keyboardType: TextInputType.name,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Name is required";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.h),
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
                              controller: vm.phoneController, // ✅ better: separate controller
                              prefix: "phone",
                              hintText: "Phone Number",
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "Phone number is required";
                                }
                                if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(v)) {
                                  return "Enter a valid phone number";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.h),
                            CustomTextField(
                              controller: vm.passwordController, // ✅ separate controller
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
                            SizedBox(height: 40.h),

                            // 🔹 Register Button
                            Row(
                              children: [
                                Expanded(
                                  child: SlantedButtonStack(
                                    text: 'REGISTER',
                                    onPressed: () {
                                      if (vm.formKey.currentState?.validate() ?? false) {
                                        // TODO: handle sign-up
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // 🔹 Already have an account?
                      InkWell(
                        onTap: () {
                          log("Navigate to Login");
                          Navigator.pushReplacementNamed(context, LoginView.routeName);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "Already have an account? ",
                              fontFamily: "Kanit",
                              fontSize: 16.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            CustomText(
                              text: "Login",
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
