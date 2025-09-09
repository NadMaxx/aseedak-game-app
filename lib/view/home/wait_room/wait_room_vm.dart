import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/view/home/game_room/game_room.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/utils/app_colors.dart';
import '../../../data/utils/app_constants.dart';
import '../../../main.dart';

class WaitingRoomVm extends BaseVm{
  List<Map<String, String>> players = [
    {
      "name": "Jack Adams",
      "avatar": "https://thumbs.dreamstime.com/b/happy-young-man-holding-tablet-his-face-displayed-screen-binary-code-happy-man-holding-tablet-his-face-317521026.jpg",
    },
    {
      "name": "Ethan Hales",
      "avatar": "https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YXZhdGFyfGVufDB8fDB8fHww",
    },
    {
      "name": "Wanda Siege",
      "avatar": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTTAUPUG0r--EDZzf-f9Afj_Jp7N96yIGsWPgCYIkrAS1rCJHIcdm_RCq_me44bJc0dvvY&usqp=CAU",
    },
    {
      "name": "Wanda Siege",
      "avatar": "https://www.shutterstock.com/image-photo/adult-female-avatar-image-on-260nw-2420293027.jpg",
    },
  ];

   showGameStartDialog(BuildContext context) async {
    showLoaderDialog();
    await Future.delayed(const Duration(seconds: 3),(){
      Navigator.pop(navigatorKey.currentContext!);
      Navigator.popAndPushNamed(navigatorKey.currentContext!, GameRoom.routeName);
    });
  }

  showLoaderDialog() {
    return showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (ctx) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20.r)
            ),
            height: 200.h,
            width: AppConstants.getScreenWidth(ctx) * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset("circle".toSvgPath),
                    CupertinoActivityIndicator(color: Colors.white,),
                  ],
                ),
                CustomText(text: "Starting Game ... (78%)")
              ],
            ),
          ),
        );
      },
    );
  }

}