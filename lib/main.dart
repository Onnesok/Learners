import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:learners/home/category/category_fetch.dart';
import 'package:learners/chat/consts.dart';
import 'package:learners/home/popular_courses/popular_courses_fetch.dart';
import 'package:learners/network_page/NoInternet.dart';
import 'package:learners/user_onboarding/login_page.dart';
import 'package:learners/user_onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learners/controller/dependency_injection.dart';
import 'package:provider/provider.dart';
import 'package:learners/profile/profile_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load(fileName: 'api_key.env');
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY'] ?? '');
  //Gemini.init(apiKey: GEMINI_API_KEY);
  DependencyInjection.init();
  WidgetsFlutterBinding.ensureInitialized();

  // Check initial connectivity
  ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
  // Preload SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingShown = prefs.getBool('onboardingShown') ?? false;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Widget initialPage;
  if (connectivityResult != ConnectivityResult.none) {
    initialPage = onboardingShown ? const login() : const Onboarding();
  } else {
    initialPage = const NoInternet();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => PopularCourseProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.orange,
        ),
        navigatorKey: navigatorKey,
        home: initialPage,
      ),
    ),
  );
}
