import 'dart:ui' as ui;

import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/game_room/game_room_vm.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:provider/provider.dart';

import '../../../widgets/customText.dart';
import '../../../widgets/thick_text.dart';

class GameRoom extends StatelessWidget {
  static const String routeName = '/gameRoom';

  const GameRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameRoomVm>(
      builder: (context, vm, _) {
        return Directionality(
          textDirection: context.locale.languageCode == 'ar'
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: PopScope(
            canPop: false,
            // onPopInvokedWithResult: (value,data) async {
            //   showCustomSheetWithContent(children: Column(
            //     children: [
            //       CustomText(
            //         text: "quit_game".tr(),
            //         fontFamily: "Kanit",
            //         fontWeight: FontWeight.w600,
            //         fontSize: 20.sp,
            //       ),
            //       SizedBox(height: 10.h,),
            //       Divider(),
            //     ],
            //   ),
            //       confirmText: "yes_quit".tr(),
            //       onConfirmPressed: () {
            //         Navigator.pop(context);
            //         Navigator.pop(context);
            //       });
            // },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: CustomText(
                  text: "Character",
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
                leading: InkWell(
                  onTap: () {
                   showCustomSheetWithContent(children: Column(
                     children: [
                       CustomText(
                         text: "quit_game".tr(),
                         fontFamily: "Kanit",
                         fontWeight: FontWeight.w600,
                         fontSize: 20.sp,
                       ),
                       SizedBox(height: 10.h,),
                       Divider(),
                     ],
                   ),
                       confirmText: "yes_quit".tr(),
                       onConfirmPressed: (){
                         Navigator.pop(context);
                     Navigator.pop(context);
                   });

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RotatedBox(
                        quarterTurns: 2,
                        child: SvgPicture.asset("back".toSvgPath)),
                  ),
                ),
              ),

              body: vm.isLoading ? Center(
                child: CustomLoader(),
              ): SizedBox(
                width: AppConstants.getScreenWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: AppConstants.getScreenHeight(context) * 0.65,
                            width: AppConstants.getScreenWidth(context) * 0.9,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("card".toPngPath),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Spacer(),
                                // Avatar image at the top
                                vm.myPlayer.character != null
                                    ? Image.network(
                                        vm.myPlayer.character!.imageUrl!,
                                        height: 300.h,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error, size: 50.h, color: AppColors.red);
                                        },
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return CustomLoader();
                                          },
                                      )
                                    :
                                Image.asset("avatar".toPngPath),
                                SizedBox(height: 10.h),

                                const Spacer(), // pushes the bottom container to bottom

                                // Bottom aligned container
                                Container(
                                  height: 72.h,
                                  margin: EdgeInsets.only(bottom: 30.h, left: 20.w, right: 20.w),
                                  width: AppConstants.getScreenWidth(context) * 0.3,
                                  decoration: BoxDecoration(
                                    color: AppColors.container,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: AppColors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  child: Center(
                                    child: ThickShadowText(
                                      text: vm.myPlayer.character?.name ?? "No Character",
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Container(
                            height: AppConstants.getScreenHeight(context) * 0.65,
                            width: AppConstants.getScreenWidth(context) * 0.9,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("card".toPngPath),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: 15.h),

                                // Avatar image at the top
                                InkWell(
                                  onTap: (){
                                    vm.claimTheWord(vm.myPlayer.words?.word1 ?? "");
                                  },
                                  child: Container(
                                    height: 96.h,
                                    margin:  EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.container,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.6),
                                          width: 4.sp

                                      ),
                                    ),
                                    child: Center(
                                      child: ThickShadowText(text: vm.myPlayer.words?.word1 ?? ""),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(10, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: SvgPicture.asset("sword".toSvgPath)
                                    );
                                  }),
                                ),
                                SizedBox(height: 15.h),
                                InkWell(
                                  onTap: (){
                                    vm.claimTheWord(vm.myPlayer.words?.word2 ?? "");
                                  },
                                  child: Container(
                                    height: 96.h,
                                    margin:  EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.container,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.6),
                                        width: 4.sp
                                      ),
                                    ),
                                    child: Center(
                                      child: ThickShadowText(text: vm.myPlayer.words?.word2 ?? ""),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(10, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: SvgPicture.asset("sword".toSvgPath)
                                    );
                                  }),
                                ),
                                SizedBox(height: 15.h),
                                InkWell(
                                  onTap: (){
                                    vm.claimTheWord(vm.myPlayer.words?.word3 ?? "");
                                  },
                                  child: Container(
                                    height: 96.h,
                                    margin:  EdgeInsets.symmetric(horizontal: 20.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.container,
                                      border: Border.all(
                                        color: AppColors.white.withOpacity(0.6),
                                          width: 4.sp
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: ThickShadowText(text: vm.myPlayer.words?.word3 ?? ""),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        height: 50.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.white.withOpacity(0.6)),
                        ),
                        child: Row(
                          children: [
                            CustomText(
                              text: "Players",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            const Spacer(),
                            CustomText(
                              text: "${vm.roomDetail.room!.players!.length}/${vm.roomDetail.room!.maxPlayers}",
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SlantedButtonStack(
                        text: "Target Assassinated".toUpperCase(),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
