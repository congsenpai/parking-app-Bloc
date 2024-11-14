import 'package:project_smart_parking_app/screens/home_screen.dart';
import 'package:project_smart_parking_app/screens/loginScreen/login_screen.dart';
import 'package:project_smart_parking_app/screens/loginScreen/welcome_screens.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configLoading();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskType = EasyLoadingMaskType.clear;
}

class MyApp extends StatelessWidget {
  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false); // Set to false after first launch
    }

    return isFirstLaunch;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      home: FutureBuilder<bool>(
        future: _isFirstLaunch(),
        builder: (context, firstLaunchSnapshot) {
          if (firstLaunchSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (firstLaunchSnapshot.data == true) {
            // If first launch, show WelcomeScreen
            return const WelcomeScreen();
          } else {
            // Otherwise, check if the user is logged in
            return FutureBuilder<UserModel?>(
              future: SecureStore().retrieve(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasData && userSnapshot.data != null) {
                  return HomeScreen(user: userSnapshot.data!);
                } else {
                  return const LoginScreen();
                }
              },
            );
          }
        },
      ),
    );
  }
}
