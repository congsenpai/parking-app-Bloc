import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/services/map_and_routing.dart';

class InProgressParking extends StatefulWidget {
  final String userId;

  const InProgressParking({
    super.key,
    required this.userId,
  });

  @override
  State<InProgressParking> createState() => _InProgressParkingState();
}

class _InProgressParkingState extends State<InProgressParking> {
  ParkingSpotRepository _parkingSpotRepository = ParkingSpotRepository();
  TransactionRepository _transactionRepository = TransactionRepository();

  void initState() {
    super.initState();
  }

  Future<String> _getPlaceNameFromOrder() async {
    List<String> placeName = await _transactionRepository
        .getParkingSpotRecentlyTransactionsByUser(widget.userId);
    return placeName.first;
  }

  Future<LatLng> _getLocationOrder() async {
    List<ParkingSpotModel> a = await _parkingSpotRepository
        .getAllParkingSpotsBySearchSpotName(await _getPlaceNameFromOrder());
    ParkingSpotModel geoPoint = a.first;
    LatLng latLng =
        LatLng(geoPoint.location.latitude, geoPoint.location.longitude);
    return latLng;
  }

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
          height: Get.width / 2,
          width: Get.width / 1.1,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/backgroundMap.png'),
            fit: BoxFit.cover,
          )),
          child: Row(
            children: [
              Container(
                width: Get.width / 1.8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on,
                        color: Colors.red, size: Get.width / 10),
                    SizedBox(width: Get.width / 40),
                  ],
                ),
              ),
              Container(
                width: Get.width / 3,
                alignment: Alignment.center,
                child: OutlinedButton(
                  onPressed: () async {
                    LatLng endPoint = await _getLocationOrder();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapWidgetScreen(endPoint: endPoint)
                      ),
                    );
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
