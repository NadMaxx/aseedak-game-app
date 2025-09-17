import 'package:aseedak/main.dart';
import 'package:aseedak/view/home/dashboard/dashboard_screen.dart';
import 'package:aseedak/view/start/auth/login/login_view.dart';
import 'package:aseedak/view/start/onboarding/onboarding.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/utils/sharedKeys.dart';

class SplashVm extends ChangeNotifier{
  SplashVm(){
    _init();
  }

  void _init() async{
    bool? isFirstTime = prefsGlobal.getBool(key: SharedPrefsKeys.isFirstTime);
    bool? loggedIn = prefsGlobal.getBool(key: SharedPrefsKeys.IS_USER_LOGGED_IN);

    await Future.delayed(const Duration(seconds: 3));
    if(isFirstTime == null || isFirstTime == true){
      Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, OnboardingScreen.routeName, (r)=>false);
    }else{
      if(loggedIn != null && loggedIn == true){
        //directly to dashboard
        Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, DashboardScreen.routeName, (r)=>false);
      }else {
        Navigator.pushNamedAndRemoveUntil(navigatorKey.currentContext!, LoginView.routeName, (r)=>false);
      }

    }
    notifyListeners();
  }
}