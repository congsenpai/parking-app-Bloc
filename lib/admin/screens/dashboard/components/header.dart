
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/components/search_widget.dart';

import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/menu_app_controller.dart';
import '../../../responsive.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),

        Expanded(child: ProfileCard()),
        // ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

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
              child: Text("Angelina Jolie"),
            ),
          Container(
            width: Get.width / 15,
              child: IconButton(onPressed: (){}, icon: Icon(Icons.logout))
              )


        ],
      ),
    );
  }
}


