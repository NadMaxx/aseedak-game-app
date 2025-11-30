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
import 'buy_games_vm.dart';

class BuyGamesScreen extends StatelessWidget {
  static const routeName = '/buyGames';

  const BuyGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.primary.withOpacity(0.95),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
          title: CustomText(
            text: "buy_games_title".tr(),
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            fontFamily: "Kanit",
          ),
        ),
        body: Consumer<BuyGamesVm>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (!vm.isAvailable) {
              return Center(
                child: CustomText(
                  text: "store_not_available".tr(),
                  color: AppColors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              itemCount: vm.products.length,
              separatorBuilder: (_, __) => SizedBox(height: 20.h),
              itemBuilder: (context, index) {
                final product = vm.products[index];
                return Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.container.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(
                      color: AppColors.white.withOpacity(0.15),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      CustomText(
                        text: product.title,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Kanit",
                      ),
                      SizedBox(height: 6.h),

                      // Subtitle / Description
                      CustomText(
                        text: product.description.isNotEmpty
                            ? product.description
                            : "Get access to more exciting game rounds!",
                        fontSize: 14.sp,
                        color: AppColors.white.withOpacity(0.8),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),

                      // Price Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.3),
                          ),
                        ),
                        child: CustomText(
                          text: product.price,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Kanit",
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Buy Button
                      SlantedButtonStack(
                        text: "buy_now".tr(),
                        onPressed: () => vm.buyProduct(product),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
