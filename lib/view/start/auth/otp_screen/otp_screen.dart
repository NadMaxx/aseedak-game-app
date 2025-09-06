import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/change_password/change_password.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/custom_button.dart';
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
        color: AppColors.secondary, // dark blue background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.white.withOpacity(0.6),
        ), // no border
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.red, // red background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 2), // white border
      ),
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white, // text in white when selected
        fontWeight: FontWeight.w600,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.secondary, // dark blue background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.white.withOpacity(0.6),
        ), // no border
      ),
    );
    return Consumer<OTPVm>(
      builder: (context, vm, child) {
        return Scaffold(
          bottomNavigationBar: SafeArea(
            child: SizedBox(
              height: 100.h,

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                child: SlantedButtonStack(
                  text: "VERIFY & CONTINUE",
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ChangePassword.routeName,
                    );
                    // Navigator.pushNamed(
                    //   context,
                    //   SuccessScreen.routeName,
                    //   arguments: SuccessPassModel(
                    //     title: "OTP Sent successfully!",
                    //     buttonText: "ENTER OTP",
                    //     message:
                    //         "We’ve sent a one-time password (OTP) to your email. Please check your inbox (and spam folder) to complete the verification process.",
                    //     route: OtpScreen.routeName,
                    //   ),
                    // );
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),
                CustomText(
                  text: "Enter OTP Code",
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                SizedBox(height: 16.h),
                CustomText(
                  text:
                      "We have sent a OTP code to your email. Please enter it below to verify your account.",
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
                          const TextSpan(text: "You can resend the code in "),
                          TextSpan(
                            text: "${vm.seconds}",
                            style: TextStyle(
                              color: AppColors.red, // red for countdown
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: " seconds"),
                        ],
                      ),
                    ),
                  ),
                ],
                if (vm.seconds == 0) ...[
                  SizedBox(height: 24.h),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        vm.startTimer();
                      },
                      child: CustomText(
                        text: "Resend Code",
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
        );
      },
    );
  }
}
