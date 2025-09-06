import 'dart:developer';

import 'package:aseedak/view/start/auth/change_password/change_password_vm.dart';
import 'package:aseedak/view/start/auth/forgot_password/forgot_password_vm.dart';
import 'package:aseedak/view/start/auth/otp_screen/otp_vm.dart';
import 'package:aseedak/view/start/auth/sign_up/sign_up_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/models/passModels/SuccessPassModel.dart';
import '../view/start/auth/change_password/change_password.dart';
import '../view/start/auth/forgot_password/forgot_password.dart';
import '../view/start/auth/login/login_view.dart';
import '../view/start/auth/login/login_vm.dart';
import '../view/start/auth/otp_screen/otp_screen.dart';
import '../view/start/auth/sign_up/sign_up.dart';
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
        create: (context) => ChangePasswordVM(),
        child: const ChangePassword(),
      );
      break;
    //
    // case FestiveView.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => FestiveVm(),
    //         child: const FestiveView(),
    //       );
    //   break;
    //
    // case TrestleBoard.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => TrestleBoardVm(),
    //         child: const TrestleBoard(),
    //       );
    //   break;
    //
    // case MenuView.routeName:
    //   String data = settings.arguments as String;
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => MenuVm(id: data),
    //         child: const MenuView(),
    //       );
    //   break;
    //
    // case PhonebookView.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => PhonebookVm(),
    //         child: const PhonebookView(),
    //       );
    //   break;
    //
    // case DocsView.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => DocsVm(),
    //         child: const DocsView(),
    //       );
    //   break;
    //
    // case ChatListView.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => ChatListVm(),
    //         child: ChatListView(),
    //       );
    //   break;
    //
    // case SupportView.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //     create: (context) => SupportVm(),
    //     child: SupportView(),
    //   );
    //   break;
    //
    // case CalendarScreen.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //     create: (context) => CalendarVm(),
    //     child: CalendarScreen(),
    //   );
    //   break;
    //
    // case MembershipView.routeName:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //         create: (context) => MembershipVm(),
    //         child: const MembershipView(),
    //       );
    //   break;
    //
    // case MeetingsView.routeName:
    //   String data = settings.arguments as String;
    //
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //     create: (context) => MeetingsVm(id: data),
    //     child: const MeetingsView(),
    //   );
    //   break;
    //
    // case NotificationView.route:
    //   builder =
    //       (context) => ChangeNotifierProvider(
    //     create: (context) => NotificationVm(),
    //     child: const NotificationView(),
    //   );
    //   break;
    // case ChatView.routeName:
    //   ChatPassModel data = settings.arguments as ChatPassModel;
    //   builder = (context) => ChangeNotifierProvider(
    //       create: (context) => ChatVm(chatPassModel: data),
    //       child: const ChatView());
    //   break;
    // case DexChartView.route:
    //   builder = (context) => MultiProvider(providers: [
    //     ChangeNotifierProvider(create: (context) => DexChartVm()),
    //     ChangeNotifierProvider(create: (context) => CustomTokenVm()),
    //   ], child: const DexChartView());
    //   break;

    default:
      return errorRoute();
  }

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
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
          title: const Text('Arggg!', style: TextStyle(color: Colors.black)),
          forceMaterialTransparency: true,
        ),
        body: const Center(child: Text('Oh No! You should not be here! ')),
      );
    },
  );
}
