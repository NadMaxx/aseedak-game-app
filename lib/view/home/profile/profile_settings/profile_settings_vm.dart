import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/models/body/UserBody.dart';
import 'package:aseedak/data/models/responses/RoomCreatedResponse.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/widgets/custom_snack.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../data/models/responses/UserModel.dart' show UserModel;
import '../../../../data/repo/auth_repo.dart';
import '../../../../data/utils/app_colors.dart';
import '../../../success_screen/success_screen.dart';

class ProfileSettingsVm extends BaseVm {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UserModel get currentUser => repo.getUserObject()!;
  AuthRepo repo = GetIt.I.get<AuthRepo>();

  ProfileSettingsVm() {
    nameController.text = currentUser.user!.firstName ?? "";
    emailController.text = currentUser.user!.email ?? "";
    phoneController.text = currentUser.user!.phoneNumber ?? "";
  }

  AuthRepo authRepo = GetIt.I.get<AuthRepo>();
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  updateProfile() async {
    setLoading(true);
    UserBody body = UserBody(
      firstName: nameController.text.trim(),
      lastName: "test",
      email: emailController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      username: currentUser.user!.username ?? "",
      avatar: currentUser.user!.avatar ?? "IMAGE1",
    );

    ApiResponse apiResponse = await authRepo.updateProfile(body: body);
    if (apiResponse.response != null &&
        (apiResponse.response?.statusCode == 200 ||
            apiResponse.response?.statusCode == 201)) {
      UserModel userModel = authRepo.getUserObject()!;
      userModel.user!.avatar = body.avatar;
      userModel.user!.firstName = body.firstName;
      userModel.user!.email = body.email;
      userModel.user!.phoneNumber = body.phoneNumber;
      userModel.user!.username = body.username;

      await authRepo.setUserObject(userModel);
      Navigator.pushNamed(
        navigatorKey.currentContext!,
        SuccessScreen.routeName,
        arguments: SuccessPassModel(
          title: "profile_settings_success_title".tr(),
          buttonText: "profile_settings_success_btn".tr(),
          route: "pop",
          removeRoute: false,
          message: "profile_settings_success_msg".tr(),
        ),
      );

    } else {
      setLoading(false);

      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        color: AppColors.red,
        isSuccess: false,
      );
    }

    setLoading(false);
  }

  // Add properties and methods for the Profile Settings ViewModel
}
