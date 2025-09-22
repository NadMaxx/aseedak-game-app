import 'dart:developer';

import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/models/body/RegisterBody.dart';
import 'package:aseedak/data/models/responses/UserModel.dart';
import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/data/utils/app_constants.dart';
import 'package:aseedak/main.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_screen.dart';
import 'package:aseedak/widgets/custom_snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class SignUpVm extends BaseVm {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignUpVm() {
    if (kDebugMode) {
      emailController.text = "asadtest@yopmail.com";
      nameController.text = "asad";
      phoneController.text = "03001234567";
      passwordController.text = "Admin@123";
    }
  }

  AuthRepo authRepo = GetIt.I.get<AuthRepo>();
  bool isLoading = false;

  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  userSignUp() async {
    if (formKey.currentState?.validate() ?? false) {
      setLoading(true);
      ApiResponse apiResponse = await authRepo.register(
        body: RegisterBody(
          fullName: nameController.text,
          email: emailController.text,
          phoneNumber: phoneController.text,
          password: passwordController.text,
        ),
      );
      if (apiResponse.response != null &&
          (apiResponse.response?.statusCode == 200  || apiResponse.response?.statusCode == 201)) {
        setLoading(false);

        notifyListeners();
        UserModel user = UserModel.fromJson(apiResponse.response?.data);
        AppConstants.currentUser = user;
        Navigator.pushNamed( navigatorKey.currentContext!, OtpScreen.routeName);
      } else {
        // MyErrorResponse myErrorResponse = MyErrorResponse.fromJson(apiResponse.error!);
        customSnack(
          text: apiResponse.error!.toString(),
          context: navigatorKey.currentContext!,
          isSuccess: false,
        );
        notifyListeners();
      }
      setLoading(false);

      notifyListeners();
    }
  }
}
