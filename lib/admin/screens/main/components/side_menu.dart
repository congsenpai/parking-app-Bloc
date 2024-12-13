import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/sidetab_element/customer_management.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/sidetab_element/spot_owner_management.dart';

import '../../dashboard/dashboard_screen.dart';
import '../../dashboard/sidetab_element/transaction-management.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.pushReplacement(context, 
                  MaterialPageRoute(
                      builder: (context)=>DashboardScreen()
                  )
              );
            },
          ),
          DrawerListTile(
            title: "Quản lý giao dịch",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>TransactionManagement(SpotName: '',)));
            },
          ),
          DrawerListTile(
            title: "Quản lý khách hàng",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> CustomerManagement(userName: '', isAdmin: true,)));
            },
          ),
          DrawerListTile(
            title: "Quản lý chủ bãi đỗ",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>SpotOwnerManagement(SpotOwnerName: '', isAdmin: true)));
            },
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),

        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
