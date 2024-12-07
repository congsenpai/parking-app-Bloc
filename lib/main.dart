import 'firebase_options.dart';
import 'blocs/home/home_bloc.dart';
import 'controlpanel/view/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:project_smart_parking_app/blocs/order/order_bloc.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_bloc.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_bloc.dart';
import 'package:project_smart_parking_app/blocs/parking_spot/spot_bloc.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';
import 'package:project_smart_parking_app/screens/OrderScreen/order_screen.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_bloc.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';
import 'package:project_smart_parking_app/screens/detailOrderScreen/detail_order_screen.dart';
import 'package:project_smart_parking_app/screens/transactionDiposited/transaction_diposited.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomeScreen(),
    );
  }
}

