import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/profile/policies/policies_page.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings.dart';
import 'package:aseedak/view/home/profile/profile_vm.dart';
import 'package:aseedak/view/start/auth/change_password/change_password.dart';
import 'package:aseedak/view/start/auth/change_password/change_password_vm.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../widgets/thick_text.dart';
import '../../start/auth/update_password/update_password.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileVm>(
      builder: (context, vm, child) {
        return Scaffold(
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
              SizedBox(height: 40.h),
              buildListTile(
                "banda",
                "Profile", () {
                  Navigator.pushNamed(context, ProfileSettings.routeName);
                },
              ),
              buildListTile(
                "taala",
                "Change Password", () {
                  Navigator.pushNamed(context, UpdatePassword.routeName);
                },
              ),
              buildListTile(
                "kaghaz",
                "Terms & Policies", () {
                Navigator.pushNamed(context, PoliciesPage.routeName);
                },
              ),
              buildListTile(
                "tokri",
                "Delete Account", () {
                  vm.showDeleteAccountSheet(context);
                  // vm.logout(context);
                },
              ),
              buildListTile(
                "bahr",
                "Logout", () {
                  vm.showLogoutSheet(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ListTile buildListTile(String image, title, onTap) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset("square".toSvgPath),

          Image.asset(image.toPngPath, height: 24.h, width: 24.w),
        ],
      ),
      title: CustomText(
        text: title,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        fontFamily: "Kanit",
      ),
      trailing: SvgPicture.asset("forward".toSvgPath),
    );
  }
}
