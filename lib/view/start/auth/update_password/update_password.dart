import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/start/auth/change_password/change_password_vm.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../widgets/customCirle.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/customTextField.dart';
import '../../../../widgets/custom_button.dart';
import '../../../success_screen/success_screen.dart';
import '../otp_screen/otp_screen.dart';

class UpdatePassword extends StatelessWidget {
  static const String routeName = '/updatePassword';
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdatePasswordVm>(builder: (context, vm, child) {
      return Scaffold(
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 100.h,

            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                child: SlantedButtonStack(text: "save new password".toUpperCase(), onPressed: (){
                  Navigator.pushNamed(context, SuccessScreen.routeName, arguments: SuccessPassModel(
                    title: "Password Updated Successfully!",
                    buttonText: "OK, Great",
                    route: "pop",
                    message: "Your password has been successfully updated. You can now log in with your new password. If you need further assistance, feel free to reach out!",
                    removeRoute: false,
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              CustomText(
                text: "Update Password",
                fontSize: 40.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              CustomText(
                text: "Choose Password different from older one.",
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                textAlign: TextAlign.center,
                fontFamily: "Kanit",
              ),
              SizedBox(height: 50.h),
              CustomText(
                text: "Current Password",
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                textAlign: TextAlign.center,
                fontFamily: "Kanit",
              ),
              CustomTextField(
                controller: vm.passwordController,
                prefix: "lock",
                hintText: "Enter Password",
                obscureText: true,
                validator: (v) {
                  if(v == null || v.isEmpty){
                    return "Password is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              CustomText(
                text: "New Password",
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                textAlign: TextAlign.center,
                fontFamily: "Kanit",
              ),
              CustomTextField(
                controller: vm.passwordController,
                prefix: "lock",
                hintText: "Enter Password",
                obscureText: true,
                validator: (v) {
                  if(v == null || v.isEmpty){
                    return "Password is required";
                  }
                  if(v.length < 6){
                    return "Password must be at least 6 characters";
                  }
                  if(!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$').hasMatch(v)){
                    return "Password must contain at least one letter and one number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomText(
                text: "Confirm New Password",
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                textAlign: TextAlign.center,
                fontFamily: "Kanit",
              ),
              CustomTextField(
                controller: vm.confirmPasswordController,
                prefix: "lock",
                hintText: "Enter Password",
                obscureText: true,
                validator: (v) {
                  if(v == null || v.isEmpty){
                    return "Password is required";
                  }
                  if(v != vm.passwordController.text){
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),


            ],
          ),
        ),
      );
    });
  }
}
