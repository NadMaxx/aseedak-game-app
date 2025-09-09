import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../data/utils/app_colors.dart';
import '../../../../widgets/customCirle.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/customTextField.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/thick_text.dart';
import '../../../success_screen/success_screen.dart';

class ProfileSettings extends StatelessWidget {
  static const String routeName = '/profileSettings';
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSettingsVm>(builder: (context, vm, child) {
      return Scaffold(
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 100.h,

            child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 20.0,
                ),
                child: SlantedButtonStack(text: "Update Profile".toUpperCase(), onPressed: (){
                  Navigator.pushNamed(context, SuccessScreen.routeName, arguments: SuccessPassModel(
                    title: "Profile Updated Successfully!",
                    buttonText: "OK, Great",
                    route: "pop",
                    removeRoute: false,
                    message: "Your profile has been updated successfully. All changes have been saved. Thank you for keeping your information up to date!"
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
                    CustomCircle(image: "person"),
                    SizedBox(height: 8.h),
                    ThickShadowText(
                      text: "John Doe",
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                    CustomText(
                      text: "alexandarfleming@gmail.com",
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
                      hintText: "Full Name",
                      keyboardType: TextInputType.name,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h,),
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
                    SizedBox(height: 20.h,),
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
                  ],
                ),
              )


            ],
          ),
        ),
      );
    });
  }
}
