import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/base_vm.dart';
import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../data/utils/app_colors.dart';
import '../../../../widgets/custom_snack.dart';
import '../../../success_screen/success_screen.dart';

class ChangePasswordVM extends BaseVm {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  //form key
  final formKey = GlobalKey<FormState>();


  AuthRepo repo = GetIt.I.get<AuthRepo>();
  bool isLoading = false;
  changePassword() async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      try{

      ApiResponse apiResponse = await repo.changePassword(
          currentPassword: oldPassword.text,
          newPassword: confirmPasswordController.text);
      if (apiResponse.response != null &&
          (apiResponse.response?.statusCode == 200 ||
              apiResponse.response?.statusCode == 201)) {
        oldPassword.clear();
        confirmPasswordController.clear();
        passwordController.clear();
        Navigator.pushNamed(
          navigatorKey.currentContext!,
          SuccessScreen.routeName,
          arguments: SuccessPassModel(
            title: "update_password_success_title".tr(),
            buttonText: "update_password_success_btn".tr(),
            route: "pop",
            message: "update_password_success_msg".tr(),
            removeRoute: false,
          ),
        );
      }else {
        customSnack(
          text: apiResponse.error?.message ?? "Something went wrong",
          context: navigatorKey.currentContext!,
          color: AppColors.red,
          isSuccess: false,
        );
      }
    }catch(E) {
        customSnack(
          text: "Something went wrong",
          context: navigatorKey.currentContext!,
          color: AppColors.red,
          isSuccess: false,
        );
      }
    isLoading = false;
    notifyListeners();
  }}
}

