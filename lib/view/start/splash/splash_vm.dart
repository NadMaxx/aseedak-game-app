import 'package:aseedak/main.dart';
import 'package:aseedak/view/start/onboarding/onboarding.dart';
import 'package:flutter/cupertino.dart';

class SplashVm extends ChangeNotifier{
  SplashVm(){
    _init();
  }

  void _init() async{
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, OnboardingScreen.routeName, (r)=>false);
    notifyListeners();
  }
}