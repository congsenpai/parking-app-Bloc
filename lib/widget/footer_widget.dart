import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class footerWidget extends StatelessWidget {
  const footerWidget({
    super.key,
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
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min, // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wordpress, size: Get.width / 15,color: Colors.blue,), // Giới hạn kích thước icon
                Text(
                  "Discovery",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue,// Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width/20,
          ),
          TextButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min, // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.car_repair_outlined, size: Get.width / 15,color: Colors.blue), // Giới hạn kích thước icon
                Text(
                  "Orders",

                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue,// Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width/20,
          ),
          TextButton(
            onPressed: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min, // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wallet, size: Get.width / 15,color: Colors.blue), // Giới hạn kích thước icon
                Text(
                  "Wallet",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue,// Giới hạn kích thước chữ
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Get.width/20,
          ),
          TextButton(
            onPressed: () {

            },
            child: Column(
              mainAxisSize: MainAxisSize.min, // Điều chỉnh kích thước theo nội dung
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: Get.width / 15,color: Colors.blue), // Giới hạn kích thước icon
                Text(
                  "Setting",
                  style: TextStyle(
                    fontSize: Get.width / 25,
                    color: Colors.blue,// Giới hạn kích thước chữ
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