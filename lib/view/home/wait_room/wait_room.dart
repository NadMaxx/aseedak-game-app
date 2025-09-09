import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/wait_room/wait_room_vm.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_button.dart';
import 'package:aseedak/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../widgets/cache_image.dart';

class WaitingRoom extends StatelessWidget {
  static const String routeName = "/waitingRoom";

  const WaitingRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaitingRoomVm>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: CustomText(
              text: "Dragon Knights",
              fontSize: 28.sp,
              fontWeight: FontWeight.w600,
            ),
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
                        text: "4/4",
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 350.h,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
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
                              link: vm.players[index]['avatar']!,
                              name: vm.players[index]['name']!,
                              radius: 10.r,
                              height: 58.h,
                              width: 58.w,
                            ),
                            SizedBox(width: 20.w),
                            CustomText(
                              text: vm.players[index]['name']!,
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
                    itemCount: vm.players.length,
                  ),
                ),
                Container(
                  height: 50.h,
                  margin: EdgeInsets.only(top: 20.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.white.withOpacity(0.6)),
                  ),
                  child:  Center(
                    child: CustomText(
                      text: "Room Link",
                      fontSize: 18.sp,
                      fontFamily: "Kanit",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                        text: "https://www.sample.info/?quince=scarf/#impulsednsjdxsmd/dscscd/scscscsc/s",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Kanit",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      SimpleSlantedButton(
                        color: AppColors.secondary,
                        text: 'SHARE LINK',onPressed: (){},)
                    ],
                  ),
                ),
                Spacer(),
                SlantedButtonStack(text: "Start game".toUpperCase(), onPressed: (){
                  vm.showGameStartDialog(context);
                }),
                SizedBox(height: 20.h),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
