import 'package:aseedak/data/utils/app_colors.dart';
import 'package:aseedak/view/start/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/generateRoutes.dart';
import 'di_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved language from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final langCode = prefs.getString('language_code') ?? 'en';
  final startLocale = Locale(langCode);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await di.init();
  await GetIt.I.allReady();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final designSize = isTablet ? const Size(810, 1080) : const Size(430, 932);

    return MultiProvider(
      providers: [
        Provider(create: (_) => Object()), // temporary placeholder
      ],
      child: ScreenUtilInit(
        designSize: designSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1)),
            child: MaterialApp(
              navigatorKey: navigatorKey,
              theme: ThemeData(
                  scaffoldBackgroundColor: AppColors.primary,
                  appBarTheme: AppBarTheme(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                  ),
                  useMaterial3: true,
                  fontFamily: "Teko"
              ),
              scaffoldMessengerKey: rootScaffoldMessengerKey,
              debugShowCheckedModeBanner: false,
              initialRoute: SplashView.route,
              onGenerateRoute: (settings) => generateRoute(settings),
            ),
          );
        },
      ),
    );
  }
}
