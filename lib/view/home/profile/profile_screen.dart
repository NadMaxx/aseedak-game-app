import 'dart:ui' as ui;

import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/profile/policies/policies_page.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings.dart';
import 'package:aseedak/view/home/profile/profile_vm.dart';
import 'package:aseedak/view/start/auth/update_password/update_password.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/thick_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileVm>(
      builder: (context, vm, child) {
        return Directionality(
          textDirection: context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: Scaffold(
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
            body: Column(
              children: [
                Container(
                  height: 250.h,
                  width: double.infinity,
                  color: AppColors.secondary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomCircle(image: "person"),
                      SizedBox(height: 8.h),
                      ThickShadowText(
                        text:  vm.currentUser.user!.firstName  ??  "" , // ⚠️ Ideally from API
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                      CustomText(
                        text:  vm.currentUser.user!.email  ??  "" , // ⚠️ Ideally from API
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
                  "profile_title".tr(),
                      () {
                    Navigator.pushNamed(context, ProfileSettings.routeName);
                  },
                ),
                buildListTile(
                  "taala",
                  "profile_change_password".tr(),
                      () {
                    Navigator.pushNamed(context, UpdatePassword.routeName);
                  },
                ),
                buildListTile(
                  "kaghaz",
                  "profile_terms_policies".tr(),
                      () {
                    Navigator.pushNamed(context, PoliciesPage.routeName);
                  },
                ),
                buildListTile(
                  "tokri",
                  "profile_delete_account".tr(),
                      () {
                    vm.showDeleteAccountSheet(context);
                  },
                ),
                buildListTile(
                  "bahr",
                  "profile_logout".tr(),
                      () {
                    vm.showLogoutSheet(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListTile buildListTile(String image, String title, VoidCallback onTap) {
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
      trailing: RotatedBox(

          quarterTurns: 2,
          child: SvgPicture.asset("forward".toSvgPath)),
    );
  }
}
