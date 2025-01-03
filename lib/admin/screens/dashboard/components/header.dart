
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/login/login.dart';
import 'package:project_smart_parking_app/models/spot_owner_model.dart';

import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/menu_app_controller.dart';

class Header extends StatelessWidget {
  final SpotOwnerModel spotOwnerModel;
  const Header({
    super.key, required this.spotOwnerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),

        Expanded(child: ProfileCard(spotOwnerModel: spotOwnerModel,)),
        // ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  final SpotOwnerModel spotOwnerModel;
  const ProfileCard({
    super.key, required this.spotOwnerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 38,
          ),
          Padding(
              padding:
                 EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(spotOwnerModel.spotOwnerName),
            ),
          SizedBox(
            width: Get.width / 15,
              child: IconButton(onPressed: (){
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=>LoginScreenAdmin()));
              }, icon: Icon(Icons.logout))
              )


        ],
      ),
    );
  }
}


