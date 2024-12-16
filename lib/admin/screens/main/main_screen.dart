
import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/spot_owner_model.dart';
import 'package:provider/provider.dart';

import '../../controllers/menu_app_controller.dart';
import '../../responsive.dart';
import '../dashboard/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  final SpotOwnerModel spotOwnerModel;
  const MainScreen({
    super.key,
    required this.spotOwnerModel,});

  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MenuAppController(),
        // we use `builder` to obtain a new `BuildContext` that has access to the provider
        builder: (context, child) {
          // No longer throws
          return Scaffold(
            key: context.read<MenuAppController>().scaffoldKey,
            drawer: SideMenu(spotOwnerModel: widget.spotOwnerModel,),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    Expanded(
                      // default flex = 1
                      // and it takes 1/6 part of the screen
                      child: SideMenu(spotOwnerModel: widget.spotOwnerModel,),
                    ),
                  Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: DashboardScreen(spotOwnerModel: widget.spotOwnerModel,),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
