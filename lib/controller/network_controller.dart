import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  bool _isDialogVisible = false;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      print("Connection gone slfmds");
      //Fluttertoast.showToast(msg: "Connection gone");

      if (!_isDialogVisible) {
        _isDialogVisible = true;

        showDialog(
          context: Get.overlayContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false, // Disable back button
              child: AlertDialog(
                title: Image.asset(
                  'assets/simple_icons/logo.png',
                  fit: BoxFit.contain,
                  height: 50,
                ),
                content: Text('Please connect to the internet.....',
                  style: TextStyle(color: Colors.black, fontFamily: "barlow_semibold", letterSpacing: 1),
                  textAlign: TextAlign.center,),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            );
          },
        );
      }

      if (!Get.isSnackbarOpen) {
        Get.rawSnackbar(
          messageText: const Text(
            'PLEASE CONNECT TO THE INTERNET',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Colors.red[400]!,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
        );
      }
    } else {
      if (_isDialogVisible) {
        _isDialogVisible = false;
        Navigator.pop(Get.overlayContext!); // Close the dialog
      }

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check initial connectivity
  ConnectivityResult connectivityResult =
  await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ));
  } else {
    runApp(GetMaterialApp(home: MyApp()));
  }
}

class MyApp extends StatelessWidget {
  final NetworkController networkController = Get.put(NetworkController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('App with Network Handling'),
        ),
        body: Center(
          child: Text('Your App Content Here'),
        ),
      ),
    );
  }
}