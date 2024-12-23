
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../chatBotService/GeminiScreen.dart';


class ServiceWidget extends StatelessWidget {
  final String userID;
  const ServiceWidget({
    super.key, required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
                  onPressed: () {


                  },
                  child: Column(
                    children: [
                      SizedBox(height: Get.width / 25),
                      CircleAvatar(
                        child: Icon(Icons.calendar_month_rounded, size: Get.width / 15, color: Colors.white),
                        minRadius: Get.width / 20,
                        backgroundColor: Colors.lightBlue,
                      ),
                      SizedBox(height: Get.width / 30),
                      Text(
                        "Monthly\nParkage",
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
          ),
          Container(
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
                  onPressed: () {



                  },
                  child: Column(
                    children: [
                      SizedBox(height: Get.width / 25),
                      CircleAvatar(
                        child: Icon(Icons.chat, size: Get.width / 15, color: Colors.white),
                        minRadius: Get.width / 20,
                        backgroundColor: Colors.lightBlue,
                      ),
                      SizedBox(height: Get.width / 30),
                      Text(
                        "Parking\nChat",
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
          ),
          Container(
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
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(title: 'ChatBot',)));

                  },
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
                        "Parking\nChatbot",
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
          )
        ])
    );

  }
}