import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/forgot_password/forgot_password_vm.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_screen.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../widgets/customCirle.dart';
import '../../../../widgets/customTextField.dart';
import '../../../../widgets/custom_button.dart';
import '../../../success_screen/success_screen.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = '/forgotPassword';

  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordVm>(
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
                  child: SlantedButtonStack(text: "SEND OTP CODE", onPressed: (){
                    Navigator.pushNamed(context, SuccessScreen.routeName, arguments: SuccessPassModel(
                      title: "OTP Sent successfully!",
                      buttonText: "ENTER OTP",
                      message: "We’ve sent a one-time password (OTP) to your email. Please check your inbox (and spam folder) to complete the verification process.",
                      route: OtpScreen.routeName,
                    ));
                  })
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
          body: Column(
            children: [
              SizedBox(height: 32.h),
              CustomCircle(image: "lock"),
              SizedBox(height: 16.h),
              CustomText(
                text: "Forgot Password?",
                fontSize: 40.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomText(
                  text:
                      "Don’t worry. We’ve got you covered. Enter your email address and we’ll send you an OTP code to reset your password.",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                  fontFamily: "Kanit",
                ),


              ),
              SizedBox(height: 50.h),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: CustomTextField(
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
              ),


            ],
          ),
        );
      },
    );
  }
}
