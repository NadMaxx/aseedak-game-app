import 'dart:async';

import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../../data/models/responses/my_api_response.dart';
import '../../../../data/repo/auth_repo.dart';
import '../../../../data/utils/app_constants.dart';
import '../../../../widgets/custom_snack.dart';
import '../../../success_screen/success_screen.dart';

class OTPVm extends BaseVm{
  TextEditingController otpController = TextEditingController();
  int _seconds = 60;
  Timer? _timer;

  OTPVm() {
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
          _seconds--;
          notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get seconds => _seconds;
  AuthRepo authRepo = GetIt.I.get<AuthRepo>();
  bool isSending = false, isVerifying = false;



  resend() async {
    isSending = true;
    notifyListeners();
      ApiResponse apiResponse = await authRepo.resendOTP(
        email: AppConstants.currentUser?.user?.email ?? "",
      );
      if (apiResponse.response != null &&
          (apiResponse.response?.statusCode == 200  || apiResponse.response?.statusCode == 201)) {
        startTimer();
        customSnack(
          text: "OTP sent successfully",
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
      } else {
        // MyErrorResponse myErrorResponse = MyErrorResponse.fromJson(apiResponse.error!);
        customSnack(
          text: apiResponse.error!.toString(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
        notifyListeners();
      }
      isSending = false;
      notifyListeners();
    }
  verify() async {
    isVerifying = true;
    notifyListeners();
      ApiResponse apiResponse = await authRepo.verifyOTP(
        email: AppConstants.currentUser?.user?.email ?? "",
        otp: otpController.text // Replace with actual OTP input
      );
      if (apiResponse.response != null &&
          (apiResponse.response?.statusCode == 200  || apiResponse.response?.statusCode == 201)) {
        Navigator.pushNamed( navigatorKey.currentContext!, SuccessScreen.routeName, arguments: SuccessPassModel(
          title: "OTP Verified successfully!",
          buttonText: "login".tr(),
          removeRoute: true,
          message: "You have successfully verified your OTP. You can now log in to your account.",
          route: LoginView.routeName,
        ));
      } else {
        // MyErrorResponse myErrorResponse = MyErrorResponse.fromJson(apiResponse.error!);
        customSnack(
          text: apiResponse.error!.toString(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
        notifyListeners();
      }
    isVerifying = false;
      notifyListeners();
    }


}