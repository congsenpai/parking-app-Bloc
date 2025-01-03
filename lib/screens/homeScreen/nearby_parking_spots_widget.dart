// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_smart_parking_app/screens/detailParkingSpotScreen/detail_parking_spot_screent.dart';
import '../../models/parking_spot_model.dart';
import '../../services/map_and_routing.dart' as Map;

class NearbyParkingSpotsWidget extends StatefulWidget {
  final String userName;
  final String userID;

  const NearbyParkingSpotsWidget({
    super.key,
    required this.parkingSpots,
    required this.userID,
    required this.userName,
  });

  final List<ParkingSpotModel> parkingSpots;

  @override
  State<NearbyParkingSpotsWidget> createState() =>
      _NearbyParkingSpotsWidgetState();
}

class _NearbyParkingSpotsWidgetState extends State<NearbyParkingSpotsWidget> {
  // Hàm tính khoảng cách
  Future<double> _calculateDistance(ParkingSpotModel model) async {
    try {
      // Chuyển đổi vị trí từ ParkingSpotModel sang LatLng
      LatLng latLng = LatLng(
        model.location.latitude,
        model.location.longitude,
      );

      // Sử dụng DistanceCalculator để tính khoảng cách
      double distance =
      await Map.DistanceCalculator.getDistanceToEndpoint(latLng);

      return distance;
    } catch (e) {
      // ignore: avoid_print
      print("Lỗi khi tính khoảng cách: $e");
      return -1; // Trả về giá trị -1 nếu có lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.parkingSpots.length,
              (index) {
            var spot = widget.parkingSpots[index];
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
                      padding: EdgeInsets.all(5.0),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParkingSpotScreen(
                            data: spot,
                            userID: widget.userID,
                            userName: widget.userName,
                            isMonthly: false,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(Get.width / 30),
                          width: Get.width / 2.2,
                          height: Get.width / 3.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://drive.google.com/uc?export=view&id=${spot.listImage[0]}",
                              ),
                              fit: BoxFit.cover,
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
                            // Sử dụng FutureBuilder để hiển thị khoảng cách
                            FutureBuilder<double>(
                              future: _calculateDistance(spot), // Gọi hàm tính khoảng cách
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Hiển thị loading khi đang tính toán
                                } else if (snapshot.hasError) {
                                  return Text('Lỗi tính khoảng cách');
                                } else if (snapshot.hasData) {
                                  return Text('${snapshot.data} mét'); // Hiển thị kết quả
                                } else {
                                  return Text('Không có dữ liệu');
                                }
                              },
                            ),
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
    );
  }
}
