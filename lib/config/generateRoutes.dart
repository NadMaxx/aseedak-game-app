import 'dart:developer';

import 'package:aseedak/view/home/dashboard/dashboard_vm.dart';
import 'package:aseedak/view/home/game_room/game_room_vm.dart';
import 'package:aseedak/view/home/profile/buy_avatar/buy_avatar_vm.dart';
import 'package:aseedak/view/home/profile/profile_settings/profile_settings_vm.dart';
import 'package:aseedak/view/home/profile/profile_vm.dart';
import 'package:aseedak/view/home/wait_room/wait_room_vm.dart';
import 'package:aseedak/view/start/auth/change_password/change_password_vm.dart';
import 'package:aseedak/view/start/auth/forgot_password/forgot_password_vm.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_vm.dart';
import 'package:aseedak/view/start/auth/sign_up/sign_up_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/passModels/SuccessPassModel.dart';
import '../view/home/dashboard/dashboard_screen.dart';
import '../view/home/game_room/game_room.dart';
import '../view/home/profile/buy_avatar/buy_avatar.dart';
import '../view/home/profile/policies/policies_page.dart';
import '../view/home/profile/profile_screen.dart';
import '../view/home/profile/profile_settings/profile_settings.dart';
import '../view/home/wait_room/wait_room.dart';
import '../view/start/auth/change_password/change_password.dart';
import '../view/start/auth/forgot_password/forgot_password.dart';
import '../view/start/auth/login/login_view.dart';
import '../view/start/auth/login/login_vm.dart';
import '../view/start/auth/otp_screen/otp_screen.dart';
import '../view/start/auth/sign_up/sign_up.dart';
import '../view/start/auth/update_password/update_password.dart';
import '../view/start/auth/update_password/update_password_vm.dart';
import '../view/start/onboarding/onboarding.dart';
import '../view/start/splash/splash_view.dart';
import '../view/start/splash/splash_vm.dart';
import '../view/success_screen/success_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {

  WidgetBuilder builder;
  switch (settings.name) {
    case SplashView.route:
      builder =
          (context) => ChangeNotifierProvider(
            create: (context) => SplashVm(),
            child: const SplashView(),
          );
      break;
      // route without provider
    case OnboardingScreen.routeName:
      builder = (context) => const OnboardingScreen();
      break;
    //
    case LoginView.routeName:
      builder =
          (context) => ChangeNotifierProvider(
            create: (context) => LoginVm(),
            child: const LoginView(),
          );
      break;

    case SignUpView.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => SignUpVm(),
        child: const SignUpView(),
      );
      break;
    //
    // case ForgotPassword.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => ForgotPassVm(),
    //         child: const ForgotPassword(),
    //       );
    //   break;
    //
    case SuccessScreen.routeName:
      SuccessPassModel successData = settings.arguments as SuccessPassModel;
      builder = (context) => SuccessScreen(model: successData);
      break;

    case PoliciesPage.routeName:
      builder = (context) => PoliciesPage();
      break;
    //
    case ForgotPassword.routeName:
      builder =
          (context) => ChangeNotifierProvider(
            create: (context) => ForgotPasswordVm(),
            child: const ForgotPassword(),
          );
      break;
      case OtpScreen.routeName:
      builder =
          (context) => ChangeNotifierProvider(
            create: (context) => OTPVm(),
            child: const OtpScreen(),
          );
      break;
    case ChangePassword.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => UpdatePasswordVm(),
        child: const ChangePassword(),
      );
      break;
    case DashboardScreen.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => DashboardVm(),
        child: const DashboardScreen(),
      );
      break;
      case ProfileScreen.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => ProfileVm(),
        child: const ProfileScreen(),
      );
      break;
      case ProfileSettings.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => ProfileSettingsVm(),
        child: const ProfileSettings(),
      );
      break;
      case UpdatePassword.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => ChangePasswordVM(),
        child: const UpdatePassword(),
      );
      break;
    case BuyAvatarScreen.routeName:
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => BuyAvatarVm(),
        child: const BuyAvatarScreen(),
      );
      break;
      case WaitingRoom.routeName:
        String roomId = settings.arguments as String;
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => WaitingRoomVm(
          roomCode: roomId
        ),
        child: const WaitingRoom(),
      );
      break;
    case GameRoom.routeName:
      String roomId = settings.arguments as String;
      builder =
          (context) => ChangeNotifierProvider(
        create: (context) => GameRoomVm(
          roomCode: roomId
        ),
        child: const GameRoom(),
      );
      break;
    default:
      return errorRoute();
  }

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // 👈 starts from LEFT
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      );
    },
    transitionDuration: const Duration(
      milliseconds: 500,
    ), // Set a custom duration for the transition
  );
}

Route<dynamic> errorRoute() {
  return MaterialPageRoute(
    builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('', style: TextStyle(color: Colors.black)),
          forceMaterialTransparency: true,
        ),
        body: const Center(child: Text('Oh No! You should not be here! ')),
      );
    },
  );
}
