import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:aseedak/widgets/custom_loader.dart';
import 'package:aseedak/widgets/custom_sheet.dart';
import 'package:aseedak/widgets/simple_button.dart';
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



  showDeleteAccountSheet(BuildContext context) {
    showCustomSheet(title: "Delete", subTitle: "Are you sure you want to delete your account?", onConfirmPressed: (){},confirmText: "YES, DELETE");
  }

  AuthRepo repo = GetIt.I.get<AuthRepo>();

  showLogoutSheet(BuildContext context) {
    showCustomSheet(title: "Logout", subTitle: "Are you sure you want to logout?", onConfirmPressed: (){
      navigatorKey.currentState?.pop();
      showDialog(
          barrierDismissible: false,
          context: context, builder: (ctx){
        return Center(
          child: CustomLoader(),
        );
      });
      userLogout();
    },confirmText: "YES, LOGOUT");
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