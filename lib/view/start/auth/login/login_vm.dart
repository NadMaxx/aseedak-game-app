import 'dart:developer';

import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/view/home/dashboard/dashboard_screen.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/models/responses/UserModel.dart';
import '../../../../data/models/responses/my_api_response.dart';
import '../../../../main.dart';
import '../../../../widgets/custom_snack.dart';

class LoginVm extends BaseVm {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginVm() {
    if (kDebugMode) {
      emailController.text = "asad@yopmail.com";
      passwordController.text = "Admin@123";
    }
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthRepo repo = GetIt.I.get<AuthRepo>();

  loginRequest() async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await repo.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {

      UserModel user = UserModel.fromJson(apiResponse.response?.data);
      await repo.setUserLoggedIn(user);
      await repo.setUserLoggedIn(user);
      if(user.user != null && !(user.user!.emailVerified ?? true)){
        ApiResponse apiResponseResult = await repo.resendOTP(email: emailController.text);
        if (apiResponseResult.response != null &&
            (apiResponseResult.response?.statusCode == 200 ||
                apiResponseResult.response?.statusCode == 201
            )) {
          _isLoading = false;
          notifyListeners();
          customSnack(
            text: "OTP sent successfully",
            context: navigatorKey.currentContext!,
            isSuccess: true,
          );
          Navigator.pushNamed(navigatorKey.currentContext!, OtpScreen.routeName);
        } else {
          log("${apiResponseResult.error}");
          customSnack(
            text: apiResponseResult.error!.toString(),
            context: navigatorKey.currentContext!,
            isSuccess: false,
          );
        }
        return;
      }
      _isLoading = false;
      notifyListeners();

      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        DashboardScreen.routeName,
        (route) => false,
      );
    } else {
      // MyErrorResponse myErrorResponse = MyErrorResponse.fromJson(apiResponse.error!);
      customSnack(
        text: apiResponse.error!.toString(),
        context: navigatorKey.currentContext!,
        isSuccess: false,
      );

      _isLoading = false;
      notifyListeners();
    }
  }
}
