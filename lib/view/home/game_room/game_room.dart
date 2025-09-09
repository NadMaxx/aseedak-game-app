import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/game_room/game_room_vm.dart';
import 'package:aseedak/widgets/custom_button.dart';
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
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: CustomText(
              text: "Character",
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

          body: SizedBox(
            width: AppConstants.getScreenWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                SizedBox(
                  height: AppConstants.getScreenHeight(context) * 0.65,
                  width: AppConstants.getScreenWidth(context) * 0.9,
                  child: Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          "card".toPngPath,
                          width: AppConstants.getScreenHeight(context) * 0.5,
                        ),
                        SizedBox(
                          width: AppConstants.getScreenHeight(context) * 0.5,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.asset("avatar".toPngPath),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 72.h,
                            margin: EdgeInsets.only(bottom: 30.h),
                            width: AppConstants.getScreenHeight(context) * 0.3,
                            decoration: BoxDecoration(
                              color: AppColors.container,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: AppColors.white.withOpacity(0.6)),
                            ),
                            child: Center(
                              child: ThickShadowText(
                                text: "الشجاع",
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                          text: "4/4",
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
        );
      },
    );
  }
}
