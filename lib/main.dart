import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_controller.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';
import 'package:project_smart_parking_app/screens/detailParkingSpot/detail_parking_spot_screent.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';

import 'blocs/home/home_bloc.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_smart_parking_app/screens/loginScreen/login_screen.dart';
import 'package:project_smart_parking_app/screens/loginScreen/welcome_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize EasyLoading here
  configLoading();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserProvider(),
          ),
          BlocProvider(
            create: (context) => HomeScreenBloc(ParkingSpotRepository()),
          ),
        ],
        child: Home(),
  )
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
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(), // Initialize EasyLoading in the builder
      home: FutureBuilder<UserModel?>(
        future: SecureStore().retrieve(), // Check user information
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading
          } else if (snapshot.hasData && snapshot.data != null) {
            // If user data is present, navigate to Home
            return LoginScreen();
          } else {
            // If no user data, navigate to Welcome
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});
  

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

