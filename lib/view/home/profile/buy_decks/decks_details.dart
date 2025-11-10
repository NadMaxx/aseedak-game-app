import 'dart:developer';
import 'dart:ui' as ui;
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/data/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'buy_decks_vm.dart';

class DeckDetailScreen extends StatelessWidget {
  final WordDeck deck;
  final BuyWordDeckVm vm;
  const DeckDetailScreen({super.key, required this.deck, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
            text: deck.name,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              /// HEADER CARD
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                margin: EdgeInsets.only(top: 50.h, bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.25),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: deck.name,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      text: deck.description,
                      fontSize: 14.sp,
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: CustomText(
                        text:
                        "${"total_words".tr()}: ${deck.words.length.toString()}",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),

              /// WORD LIST
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 80.h),
                  itemCount: deck.words.length,
                  itemBuilder: (context, index) {
                    final word = deck.words[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.container,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: word.word1,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          SizedBox(height: 6.h),
                          CustomText(
                            text: word.word2,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: word.word3,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              /// BUY BUTTON (if deck is paid and not purchased)
              if (deck.price > 0 && !deck.isPurchased)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: SlantedButtonStack(
                      text: "${"buy_now".tr()} (\$5)",
                      onPressed: () {

                        log("aidgayjsdfguasuduasd");
                      vm
                            .buyDeck(deck);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
