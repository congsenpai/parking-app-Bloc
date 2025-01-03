import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:project_smart_parking_app/admin/screens/dashboard/sidetab_element/customer_management.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/sidetab_element/spot_owner_management.dart';

import '../../../../models/spot_owner_model.dart';

import '../../dashboard/sidetab_element/spot_management.dart';
import '../../dashboard/sidetab_element/transaction_management.dart';


class SideMenu extends StatelessWidget {
  final SpotOwnerModel spotOwnerModel;
  const SideMenu({


    super.key, required this.spotOwnerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(Get.width/10),
            child: IconButton(
              icon: Image.asset(
                'assets/images/logo.png', // Đường dẫn đến ảnh của bạn
                width: Get.width/3, // Kích thước icon
              ),
              onPressed: (){
              },
            ),
          ),
          DrawerListTile(
            title: "Quản lý giao dịch",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context)=>TransactionManagement(SpotName: '', spotOwnerModel: spotOwnerModel,)));
            },
          ),
          DrawerListTile(
            title: "Quản lý khách hàng",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> CustomerManagement(userName: '', isAdmin: spotOwnerModel.isAdmin, spotID: spotOwnerModel.spotID,)));
            },
          ),
          spotOwnerModel.isAdmin == true ?
          DrawerListTile(
            title: "Quản lý chủ bãi đỗ",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>SpotOwnerManagement(SpotOwnerName: '', isAdmin: true)));
            },
          ):
          DrawerListTile(
            title: "Quản lý bãi đỗ",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>SpotManagement(spotName: spotOwnerModel.spotOwnerName, isAdmin: false,)));
            },
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
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  });

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
