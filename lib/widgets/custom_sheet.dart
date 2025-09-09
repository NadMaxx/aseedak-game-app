import 'package:aseedak/main.dart';
import 'package:aseedak/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/utils/app_colors.dart';
import 'customText.dart';
import 'custom_button.dart';

Future<void> showCustomSheet({
  required String title,
  required String subTitle,
  String? cancelText,
  String? confirmText,
  required Function() onConfirmPressed,
  Function()? onCancelPressed,
}) {
  return showModalBottomSheet(
    context: navigatorKey.currentContext!,
    backgroundColor: AppColors.primary,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(
              color: Colors.white30
            )
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 16.h),

            /// Title
            CustomText(
              text: title,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),

            SizedBox(height: 12.h),
            Divider(),
            SizedBox(height: 10.h),

            /// Message
            CustomText(
              text: subTitle,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              textAlign: TextAlign.center,
              fontFamily: "Kanit",
            ),
            SizedBox(height: 10.h),

            Divider(),

            SizedBox(height: 24.h),

            /// Buttons Row
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: SimpleSlantedButton(
                      text: cancelText ?? "CANCEL",
                      onPressed:onCancelPressed ?? () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SlantedButtonStack(
                      text: confirmText ?? "YES",
                      onPressed: onConfirmPressed)
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      );
    },
  );
}


Future<void> showCustomSheetWithContent({
  required Widget children,
  String? cancelText,
  String? confirmText,
  required Function() onConfirmPressed,
  Function()? onCancelPressed,
}) {
  return showModalBottomSheet(
    context: navigatorKey.currentContext!,
    backgroundColor: AppColors.primary,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(
                top: BorderSide(
                    color: Colors.white30
                )
            )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 16.h),
            children,
            /// Buttons Row
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: SimpleSlantedButton(
                      text: cancelText ?? "CANCEL",
                      onPressed:onCancelPressed ?? () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                      child: SlantedButtonStack(
                          text: confirmText ?? "YES",
                          onPressed: onConfirmPressed)
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      );
    },
  );
}
