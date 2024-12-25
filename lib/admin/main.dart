

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/login/login.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/sidetab_element/transaction-management.dart';
import 'package:project_smart_parking_app/admin/screens/main/main_screen.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';
import 'package:provider/provider.dart';


import 'constants.dart';
import 'controllers/menu_app_controller.dart';

class MyAppAdmin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: LoginScreenAdmin(),
      ),
    );
  }
}


