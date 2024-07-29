import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:learners/home_page.dart';
import 'package:learners/network_page/NoInternet.dart';
import 'package:learners/user_onboarding/login_page.dart';
import 'package:learners/user_onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learners/controller/dependency_injection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
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



  if (connectivityResult != ConnectivityResult.none) {
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
      ),
      navigatorKey: navigatorKey,
      home: onboardingShown
          ? login()
          : Onboarding(),
    ),
    );
  } else{
    runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoInternet(),
    ));
  }
}







