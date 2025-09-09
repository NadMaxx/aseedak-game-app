import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/data/utils/string_helpers.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/view/home/wait_room/wait_room.dart';
import 'package:aseedak/widgets/customCirle.dart';
import 'package:aseedak/widgets/customText.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/base_vm.dart';
import '../../../widgets/customTextField.dart';

class DashboardVm extends BaseVm {
  showCreateRoomSheet() {
    TextEditingController roomController = TextEditingController();
    TextEditingController playerController = TextEditingController();
    showCustomSheetWithContent(
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                CustomText(
                  text: "Room Name",
                  fontFamily: "Kanit",
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
                CustomTextField(
                  controller: roomController,
                  prefix: "kamra",
                  hintText: "Enter rooms name",
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Room name is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),

                CustomText(
                  text: "Select Players",
                  fontFamily: "Kanit",
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                ),
                CustomTextField(
                  controller: roomController,
                  prefix: "bandy",
                  hintText: "Enter number of players",
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Number of players required";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          Divider(),
        ],
      ),
      onConfirmPressed: () async{
        Navigator.pop(navigatorKey.currentContext!);
        showLoaderDialog();
        await Future.delayed(Duration(seconds: 3),(){
          Navigator.pop(navigatorKey.currentContext!);
          Navigator.pushNamed(navigatorKey.currentContext!, WaitingRoom.routeName);
        });
      },
    );
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
                CustomText(text: "Creating Room ... (78%)")
              ],
            ),
          ),
        );
      },
    );
  }
}
