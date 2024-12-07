
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_bloc.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_bloc.dart';
import 'package:project_smart_parking_app/blocs/order/order_bloc.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_bloc.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_bloc.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';
import 'package:project_smart_parking_app/screens/OrderScreen/order_screen.dart';
import 'package:project_smart_parking_app/screens/detailOrderScreen/detail_order_screen.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';
import 'package:project_smart_parking_app/screens/settingScreen/setting_screen.dart';
import 'package:project_smart_parking_app/screens/transactionDiposited/transaction_diposited.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';
import 'package:project_smart_parking_app/services/theme_app.dart';
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
          BlocProvider(
              create: (context)=> ParkingSpotBloc()),
          BlocProvider(create: (context)=> BookingScreenBloc()),
          BlocProvider(create: (context)=> WalletBloc(WalletRepository(), TransactionRepository())
          ),
          BlocProvider(create: (context)=> OrderScreenBloc(TransactionRepository())
          ),
          BlocProvider(create: (context)=> OrderDetailScreenBloc(TransactionRepository()))
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

// ignore: use_key_in_widget_constructors
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

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ThemeMode _themeMode = ThemeMode.light; // Mặc định là sáng

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme, // Chế độ sáng
      darkTheme: darkTheme, // Chế độ tối
      themeMode: _themeMode, // Điều khiển theme hiện tại
      home: HomeScreen(),
    );
  }
}

