import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/screens/OrderScreen/order_screen.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../screens/settingScreen/setting_screen.dart';

class footerWidget extends StatelessWidget {
  final String userID; // Thêm biến này để lưu trữ thông tin user
  final String userName;

  const footerWidget({
    super.key,
    required this.userID,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.width / 6, // Điều chỉnh chiều cao của bottom navigation
      color: Colors.grey[200],
      child: Padding(
        padding: EdgeInsets.only(left: Get.width / 12,right: Get.width / 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(
                'assets/icons/icon_vip/12.png', // Đường dẫn đến ảnh của bạn
                width: 45, // Kích thước icon
                height: 45,
              ),
              onPressed: () async {
                final userModel =
                    await Provider.of<UserProvider>(context, listen: false)
                        .loadUser();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen(user: userModel!)));
              },
            ),
            SizedBox(
              width: Get.width / 20,
            ),
            IconButton(
              icon: Image.asset(
                'assets/icons/icon_vip/23.png', // Đường dẫn đến ảnh của bạn
                width: 45, // Kích thước icon
                height: 45,
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyOrdersScreen(userID: userID, userName: userName)));
              },
            ),
            SizedBox(
              width: Get.width / 20,
            ),
            IconButton(
              icon: Image.asset(
                'assets/icons/icon_vip/24.png', // Đường dẫn đến ảnh của bạn
                width: 45, // Kích thước icon
                height: 45,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalletScreen(
                              userID: userID,
                              userName2: userName,
                            )));
              },
            ),
            SizedBox(
              width: Get.width / 20,
            ),
            IconButton(
              icon: Image.asset(
                'assets/icons/icon_vip/31.png', // Đường dẫn đến ảnh của bạn
                width: 45, // Kích thước icon
                height: 45,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingsScreen(userID: userID, userName: userName)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
