import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/screens/OrderScreen/order_screen.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';


class footerWidget extends StatelessWidget {
  final String userID; // Thêm biến này để lưu trữ thông tin user
  const footerWidget({
    super.key, required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.width / 6, // Điều chỉnh chiều cao của bottom navigation
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              final userModel =
                  await Provider.of<UserProvider>(context, listen: false)
                      .loadUser();
              Get.to(HomeScreen(user: userModel!));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wordpress,
                  size: Get.width / 15,
                  color: Colors.blue,
                ),
                // Giới hạn kích thước icon
                Text(
                  "Discovery",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue, // Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width / 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyOrdersScreen(userID: userID,)));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.car_repair_outlined,
                    size: Get.width / 15,
                    color: Colors.blue), // Giới hạn kích thước icon
                Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue, // Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width / 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WalletScreen(
                          userID: userID)));
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wallet, size: Get.width / 15, color: Colors.blue),
                // Giới hạn kích thước icon
                Text(
                  "Wallet",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue,
                    // Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width / 20,
          ),
          TextButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: Get.width / 15, color: Colors.blue),
                // Giới hạn kích thước icon
                Text(
                  "Setting",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue, // Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
