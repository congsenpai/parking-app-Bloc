
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../models/parking_spot_model.dart';

import 'header_text.dart';

class ParkingSportBySearch extends StatelessWidget {
  const ParkingSportBySearch({
    super.key,
    required this.parkingSpotsBySearch,
  });

  final List<ParkingSpotModel> parkingSpotsBySearch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderText(textInSpan1: 'Search', textInSpan2: 'Result'),
        SizedBox(height: Get.width/30),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Row(
            children: List.generate(
              parkingSpotsBySearch.length, (index) {
              var spot = parkingSpotsBySearch[index];
              print(spot.spotId);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width / 40),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        backgroundColor: Colors.white,
                        padding:  EdgeInsets.all(5.0),
                      ),
                      onPressed: () {
                      },
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Get.width / 30),
                            width: Get.width / 1.2,
                            height: Get.width / 2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://drive.google.com/uc?export=view&id=${spot.listImage[0]}",
                                ), // Đảm bảo đường dẫn hình ảnh đúng
                                fit: BoxFit.cover, // Đặt chế độ hiển thị hình ảnh (cover, fill, contain, ...)
                              ),
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          Text(
                            spot.spotName,
                            style: TextStyle(
                              fontSize: Get.width / 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: Get.width / 30),
                          Row(
                            children: [
                              Icon(Icons.add_road_rounded, color: Colors.black),
                              SizedBox(width: 5),
                              Text("1.3 km"),
                              SizedBox(width: Get.width / 10),
                              Icon(Icons.monetization_on_outlined, color: Colors.black),
                              SizedBox(width: 5),
                              Text("${spot.costPerHourMoto}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            ),
          ),
        ),
      ],
    );
  }
}