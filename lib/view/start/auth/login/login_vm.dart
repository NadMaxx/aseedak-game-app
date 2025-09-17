import 'package:aseedak/data/base_vm.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/view/home/dashboard/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/models/responses/UserModel.dart';
import '../../../../data/models/responses/my_api_response.dart';
import '../../../../main.dart';
import '../../../../widgets/custom_snack.dart';

class LoginVm extends BaseVm{
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();


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
      _isLoading = false;
      notifyListeners();
      UserModel user = UserModel.fromJson(apiResponse.response?.data);
      await repo.setUserLoggedIn(user);
      await repo.setUserLoggedIn(user);
      Navigator.pushNamedAndRemoveUntil(
        navigatorKey.currentContext!,
        DashboardScreen.routeName,
            (route) => false,
      );
    } else {
      // MyErrorResponse myErrorResponse = MyErrorResponse.fromJson(apiResponse.error!);
      customSnack(text: apiResponse.error!.toString(), context: navigatorKey.currentContext!, isSuccess: false);

      _isLoading = false;
      notifyListeners();

    }
  }

}