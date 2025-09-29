import 'dart:ui' as ui;

import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/wait_room/wait_room_vm.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // ✅ For tr()

import '../../../widgets/cache_image.dart';
import '../../../widgets/custom_sheet.dart';

class WaitingRoom extends StatelessWidget {
  static const String routeName = "/waitingRoom";

  const WaitingRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality( // ✅ RTL/LTR support
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Consumer<WaitingRoomVm>(
        builder: (context, vm, _) {
          return PopScope(
            // onPopInvokedWithResult: (pop,v){
            //   if(vm.willPop) {
            //     vm.leaveRoom();
            //   }
            // },
            canPop: false,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: CustomText(
                  text:  vm.roomDetail.room?.name  ?? "",
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                ),
                leading: InkWell(
                  onTap: () {
                    showCustomSheetWithContent(children: Column(
                      children: [
                        CustomText(
                          text: "quit_room".tr(),
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
                          vm.leaveRoom();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RotatedBox(quarterTurns: 2,
                    child: SvgPicture.asset("back".toSvgPath)),
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: AppColors.white.withOpacity(0.6)),
                      ),
                      child: Row(
                        children: [
                          CustomText(
                            text: "waiting_room_players".tr(),
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          if(vm.roomDetail.room != null)
                          CustomText(
                            text: "${vm.roomDetail.room!.players!.length}/${vm.roomDetail.room!.maxPlayers}", // ✅ dynamic players
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 350.h,
                      child:
                      vm.isLoading ?
                          Center(
                            child: CustomLoader(),
                          ):
                      RefreshIndicator(
                        onRefresh: () async {
                          await vm.getRoomDetails(false);
                        },
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            var player = vm.roomDetail.room?.players?[index];
                            return Container(
                              height: 78.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                color: AppColors.container,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CacheImage(
                                    link: player?.user?.avatar ?? "" ,
                                    name: player?.user?.firstName ?? "",
                                    radius: 10.r,
                                    height: 58.h,
                                    width: 58.w,
                                  ),
                                  SizedBox(width: 20.w),
                                  CustomText(
                                    text: player?.user?.firstName ?? "",
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Kanit",
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 12.h);
                          },
                          itemCount:vm.roomDetail.room!.players!.length,
                        ),
                      ),
                    ),
                    Container(
                      height: 50.h,
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(10),
                        border:
                        Border.all(color: AppColors.white.withOpacity(0.6)),
                      ),
                      child: Center(
                        child: CustomText(
                          text: "waiting_room_room_link".tr(),
                          fontSize: 18.sp,
                          fontFamily: "Kanit",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.container,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.white.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "https://www.sample.info?roomCode=${vm.roomDetail.room?.code}",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Kanit",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          SimpleSlantedButton(
                            color: AppColors.secondary,
                            text: "waiting_room_share_link".tr().toUpperCase(),
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    if(!vm.isLoading)
                    if(vm.authRepo.getUserObject()!.user!.id! == vm.roomDetail.room!.creator!.id!)
                     SlantedButtonStack(
                      text: "waiting_room_start_game".tr().toUpperCase(),
                      onPressed: () {
                        vm.showGameStartDialog(context);
                      },
                    ),
                    SizedBox(height: 20.h),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
