import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class InProgressParking extends StatefulWidget {

  final String url;
  final String placeName;
  final String location;

  const InProgressParking({
    super.key,
    required this.url,
    required this.placeName,
    required this.location,
  });

  @override
  State<InProgressParking> createState() => _InProgressParkingState();
}

class _InProgressParkingState extends State<InProgressParking> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: Get.width / 25),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "In Progress Parking to",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Get.width / 15,
        ),
        Container(
          height: Get.width / 3,
          width: Get.width / 1.1,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: Get.width / 1.8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.white, size: Get.width / 10),
                    SizedBox(width: Get.width / 40),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${widget.placeName}\n",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: "${widget.location}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
              Container(
                width: Get.width / 3,
                alignment: Alignment.center,
                child: OutlinedButton(
                  onPressed: () {
                    // Mở URL (bản đồ) khi nhấn vào nút
                    Get.toNamed(widget.url);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1),
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    foregroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Open Maps',
                    style: TextStyle(
                      fontSize: Get.width / 25,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}