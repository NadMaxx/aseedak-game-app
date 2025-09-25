import 'package:aseedak/data/models/responses/my_api_response.dart';
import 'package:aseedak/data/repo/auth_repo.dart';
import 'package:aseedak/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/base_vm.dart';
import '../../../../data/models/passModels/SuccessPassModel.dart';
import '../../../success_screen/success_screen.dart';
import '../otp_screen/otp_screen.dart';

class ForgotPasswordVm extends BaseVm{
  TextEditingController emailController = TextEditingController();
  //form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthRepo authRepo =  GetIt.I.get<AuthRepo>();

  bool isSending = false;

  sendResetLink() async {
    isSending = true;
    notifyListeners();
    ApiResponse response = await authRepo.forgotPassword(email: emailController.text.trim());
    if(response.response != null && (response.response?.statusCode == 200 || response.response?.statusCode == 201)){
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        SuccessScreen.routeName,
        arguments: SuccessPassModel(
          title: "تم إرسال رمز التحقق (OTP) بنجاح!",
          buttonText: "أدخل رمز التحقق",
          message: "لقد أرسلنا رمز تحقق لمرة واحدة (OTP) إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد (ومجلد الرسائل غير المرغوب فيها) لإكمال عملية التحقق.",
          route: OtpScreen.routeName,
        ),
      );

    } else {
      // Handle error
    }
    isSending = false;
    notifyListeners();
  }
}