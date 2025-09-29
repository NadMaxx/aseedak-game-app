import 'dart:ui' as ui;

import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/dashboard/dashboard_vm.dart';
import 'package:aseedak/view/home/profile/profile_screen.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardVm>(builder: (context, vm, child) {
      return Directionality(
        textDirection: context.locale.languageCode == 'ar'
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "dashboard_hi_welcome".tr(),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: "Kanit",
                ),
                CustomText(
                  text: "dashboard_subtitle".tr(),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontFamily: "Kanit",
                ),
              ],
            ),
            actions: [
              SvgPicture.asset("bell".toSvgPath),
              SizedBox(width: 16.w),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                },
                child: SvgPicture.asset("profile".toSvgPath),
              ),
              SizedBox(width: 16.w),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24.h),
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 35).r,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12.r),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.6)),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset("vs".toSvgPath),
                        SizedBox(height: 24.h),
                        CustomText(
                          text: "dashboard_message".tr(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Kanit",
                          color: Colors.white,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        SlantedButtonStack(
                          text: "dashboard_create_room".tr(),
                          onPressed: () {
                            vm.showCreateRoomSheet();
                          },
                        ),
                        SizedBox(height: 16.h),
                        SlantedButtonStack(
                          text: "dashboard_join_room".tr(),
                          onPressed: () {
                            vm.showJoinRoomSheet();
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
