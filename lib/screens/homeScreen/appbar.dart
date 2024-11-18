
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class appbar extends StatelessWidget {
  const appbar({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      flexibleSpace: SafeArea(
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: Get.width / 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.width / 40,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const CircleAvatar(
                                minRadius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              width: Get.width / 40,
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Ha Gia",
                                  style: TextStyle(color: Color(0xFFFAF9F6)),
                                ),
                                Text(
                                  "Bao",
                                  style: TextStyle(
                                      color: Color(0xFFFAF9F6), fontSize: 18),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.width / 15,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Get Your\n", // Dòng đầu tiên
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.5), // Màu bóng
                                    offset: const Offset(2, 2), // Vị trí bóng
                                    blurRadius: 5.0, // Độ mờ
                                  ),
                                ],
                              ),
                            ),
                            TextSpan(
                              text: "Secure Park", // Dòng thứ hai
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withOpacity(0.5), // Màu bóng
                                    offset: const Offset(2, 2), // Vị trí bóng
                                    blurRadius: 5.0, // Độ mờ
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  child: Image.asset(
                    "assets/images/AnhAppbar.png",
                    width: Get.width / 2.5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width / 20, vertical: Get.width / 50),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name or city area',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}