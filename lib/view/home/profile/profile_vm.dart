import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/models/responses/UserModel.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:aseedak/widgets/simple_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../../../data/utils/app_colors.dart';
import '../../../../widgets/customText.dart';
import '../../../../widgets/custom_button.dart';
import '../../../main.dart';
import '../../../widgets/custom_snack.dart';


class ProfileVm extends BaseVm{
  UserModel get currentUser => repo.getUserObject()!;
  AuthRepo repo = GetIt.I.get<AuthRepo>();


  showDeleteAccountSheet(BuildContext context) {
    showCustomSheet(title: "delete_account_title".tr(), subTitle: "delete_account_message".tr(),
        cancelText: "cancel".tr(),
        onConfirmPressed: (){},confirmText: "confirm_delete_account".tr());
  }


  showLogoutSheet(BuildContext context) {
    showCustomSheet(title: "logout".tr(), subTitle: "logout_message".tr(),
        cancelText: "cancel".tr(),
        onConfirmPressed: (){
      navigatorKey.currentState?.pop();
      showDialog(
          barrierDismissible: false,
          context: context, builder: (ctx){
        return Center(
          child: CustomLoader(),
        );
      });
      userLogout();
    },confirmText: "confirm_logout".tr());
  }
  userLogout()async{
    ApiResponse apiResponse = await repo.logout();
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      await repo.clearSharedData();
      navigatorKey.currentState?.pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
    } else {
      customSnack(
        text: apiResponse.error?.message ?? "Something went wrong",
        context: navigatorKey.currentContext!,
        color: AppColors.red, isSuccess: false,
      );
    }
  }
}