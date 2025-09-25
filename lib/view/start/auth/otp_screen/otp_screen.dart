import 'dart:developer';
import 'dart:ui' as ui;

import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/change_password/change_password.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_vm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_snack.dart';
import '../../../success_screen/success_screen.dart';

class OtpScreen extends StatelessWidget {
  static const String routeName = '/otpScreen';

  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 90.w,
      height: 60.h,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.white.withOpacity(0.6),
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.red,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2),
      ),
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.white.withOpacity(0.6),
        ),
      ),
    );

    return Consumer<OTPVm>(
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
                  child: vm.isVerifying  ?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
                  SlantedButtonStack(
                    text: "verify".tr(), // 🔹 from localization
                    onPressed: () {
                      if(vm.otpController.text.length < 4) {
                        customSnack(
                          text: "Please enter valid OTP".tr(),
                          context: context,
                          isSuccess: false,
                        );
                        return;
                      }
                      log("Current User: ${vm.authRepo.getUserObject() != null}");
                      // return;
                      if(vm.authRepo.getUserObject() != null ) {
                        vm.verifyAndLogin();
                        return;
                    }
                      if(AppConstants.currentUser != null){
                        vm.verify();
                      } else {
                        Navigator.pushNamed(
                          context,
                          ChangePassword.routeName,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              leading: RotatedBox(
                quarterTurns:
                    context.locale.languageCode == 'ar' ? 2 : 0, // Adjust for RTL
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset("back".toSvgPath),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  CustomText(
                    text: "enter_otp".tr(), // 🔹 Enter OTP
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16.h),
                  CustomText(
                    text: "otp_sent".tr(), // 🔹 OTP sent message
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontFamily: "Kanit",
                  ),
                  SizedBox(height: 50.h),
                  Pinput(
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    controller: vm.otpController,
                    showCursor: true,
                  ),
                  SizedBox(height: 24.h),
                  if (vm.seconds > 0) ...[
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Kanit",
                          ),
                          children: [
                            TextSpan(text: "You can resend the code in ".tr()),
                            TextSpan(
                              text: "${vm.seconds}",
                              style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: " seconds".tr()),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if(vm.seconds == 0 && vm.isSending == true) ...[
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: const CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      )
                    ),
                  ],
                  if (vm.seconds == 0 && vm.isSending == false) ...[
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          vm.resend();
                        },
                        child: CustomText(
                          text: "resend_otp".tr(), // 🔹 Resend Code
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
