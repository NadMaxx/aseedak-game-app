import 'dart:ui' as ui;
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'buy_avatar_vm.dart';

class BuyAvatarScreen extends StatelessWidget {
  static const String routeName = "/buyAvatar";

  const BuyAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
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
        body: Consumer<BuyAvatarVm>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.avatars.isEmpty) {
              return Center(child: CustomText(text: "no_avatars_available".tr()));
            }

            return Center(
              child: SizedBox(
                height: 600.h,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.avatars.length,
                  itemBuilder: (context, index) {
                    final avatar = vm.avatars[index];
                    final canUse = vm.canUse(avatar);

                    return Container(
                      margin: EdgeInsets.only(right: 25.w),
                      width: screenWidth * 0.75,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("card".toPngPath),
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
                            Image.network(
                              avatar.imageUrl,
                              height: 250.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 20.h),

                            // Avatar name
                            CustomText(
                              text: avatar.name,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Kanit",
                            ),
                            SizedBox(height: 12.h),

                            // Price badge if not usable
                            if (!canUse && avatar.isPaid)
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
                                  text: "\$3",
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Kanit",
                                  color: AppColors.white,
                                ),
                              ),
                            SizedBox(height: 20.h),
                            canUse ? SizedBox() :
                            // Buy / Use button
                            SlantedButtonStack(
                              text: canUse ? "use_avatar".tr() : "buy_now".tr(),
                              onPressed: () {
                                // if (canUse) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(content: Text("avatar_selected".tr())),
                                //   );
                                // } else {
                                  vm.buyAvatar(avatar);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
