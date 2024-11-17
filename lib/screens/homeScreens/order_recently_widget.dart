
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';


class OrderRecentlyWidget extends StatelessWidget {
  const OrderRecentlyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(10, (index) {
          return Container(
            width: Get.width / 3.5,
            height: Get.width / 2.5,
            margin: EdgeInsets.only(left: Get.width / 25),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.grey[100],
                    padding: const EdgeInsets.all(5.0),
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      SizedBox(height: Get.width / 25),
                      CircleAvatar(
                        child: Icon(Icons.park, size: Get.width / 15, color: Colors.white),
                        minRadius: Get.width / 20,
                        backgroundColor: Colors.lightBlue,
                      ),
                      SizedBox(height: Get.width / 30),
                      Text(
                        "Park Lot",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: Get.width / 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}