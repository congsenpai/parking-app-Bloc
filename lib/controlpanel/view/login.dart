import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LandscapeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập cho nhà quản trị")),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: Get.width/2.9,
                      padding: EdgeInsets.all(Get.width/30),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      width: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Đăng nhập",
                            style: TextStyle(
                              fontSize: Get.width/40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Get.width/50),
                          const TextField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: Get.width/50),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Mật khẩu",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: Get.width/50),
                          ElevatedButton(
                            onPressed: () {
                              // Xử lý đăng nhập
                            },
                            child: Center(child: Text("Đăng nhập"),)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text("Vui lòng xoay thiết bị!"));
        },
      ),
    );
  }
}
