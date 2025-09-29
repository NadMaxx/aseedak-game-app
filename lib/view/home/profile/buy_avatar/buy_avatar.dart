import 'dart:ui' as ui;
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BuyAvatarScreen extends StatelessWidget {
  static const String routeName = "/buyAvatar";

  const BuyAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection:
          context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: "buy_avatar_title".tr(),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Kanit",
          ),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RotatedBox(
                quarterTurns: 2,
                child: SvgPicture.asset("back".toSvgPath),
              ),
            ),
          ),
        ),
        body: Center(
          child: SizedBox(
            height: 600.h,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: 6, // 🔥 Example: 6 avatars
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 25.w),
                  width: screenWidth * 0.75, // ✅ fixed width
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("card".toPngPath), // background card
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.white.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar image
                        Image.asset(
                          "avatar".toPngPath,
                          height: 250.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 20.h),

                        // Avatar name
                        CustomText(
                          text: "${"buy_avatar_name".tr()}${index + 1}",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Kanit",
                        ),
                        SizedBox(height: 12.h),

                        // 🔥 Price with decoration
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.container.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.white.withOpacity(0.7),
                              width: 2,
                            ),
                          ),
                          child: CustomText(
                            text: "${(index + 1) * 5} \$",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Kanit",
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Buy button
                        SlantedButtonStack(
                          text: "buy_now".tr(),
                          onPressed: () {
                            // handle purchase
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
