import 'dart:ui' as ui;
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'buy_decks_vm.dart';
import 'decks_details.dart';


class BuyWordDeckScreen extends StatelessWidget {
  static const routeName = "/buyWordDeck";

  const BuyWordDeckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
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
            text: "buy_word_deck_title".tr(),
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            fontFamily: "Kanit",
          ),
        ),
        body: Consumer<BuyWordDeckVm>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.decks.isEmpty) {
              return Center(
                child: CustomText(text: "no_word_decks_available".tr()),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.8,
              ),
              itemCount: vm.decks.length,
              itemBuilder: (context, index) {
                final deck = vm.decks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeckDetailScreen(deck: deck, vm: vm),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.container.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.white.withOpacity(0.4)),
                    ),
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: deck.name,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8.h),
                        CustomText(
                          text: "${"total_words".tr()}: ${deck.words.length}",
                          fontSize: 18.sp,
                        ),
                        SizedBox(height: 8.h),
                        if (deck.price > 0 && !deck.isPurchased)
                          CustomText(
                            text: "\$5",
                            fontSize: 16.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          )
                      ],
                    ),
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
