// ignore_for_file: unused_local_variable, unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/services/GoogleMap.dart';
import '../models/parking_spot_model.dart';
class ParkingSpotRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ParkingSpotModel>> getAllParkingSpots() async {
    try {
      List<ParkingSpotModel> parkingSpots = [];
      QuerySnapshot snapshot = await _firestore.collection('ParkingSpots').get();
      for (var doc in snapshot.docs) {
        parkingSpots.add(ParkingSpotModel.fromJson(doc.data() as Map<String, dynamic>));
        //print(parkingSpots);
      }
      return parkingSpots;
    } catch (e) {
      print('Error fetching parking spots: $e');
      return [];
    }
  }
  Future<List<ParkingSpotModel>> getAllParkingSpotsBySearchSpotName(String query) async {
    try {
      final allSpots = await getAllParkingSpots();
      // Lọc các ParkingSpotModel chứa chuỗi tìm kiếm
      final filteredSpots = allSpots
          .where((spot) => spot.spotName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      // print('Filtered spots: $filteredSpots');
      return filteredSpots;
    } catch (e) {
      print('Error searching for parking spots: $e');
      return [];
    }
  }
  Future<List<ParkingSpotModel>> getParkingSpotbyRecentlyTransaction(String userID) async{
      try {
        List<String> SpotName = await TransactionRepository().getParkingSpotRecentlyTransactionsByUser(userID);
        print(SpotName);

        final allSpots = await getAllParkingSpots();
        // Lọc các ParkingSpotModel chứa chuỗi tìm kiếm
        final filteredSpots = allSpots
            .where((spot) => SpotName.contains(spot.spotName))
            .toList();
        print('Filtered spots: $filteredSpots');
        return filteredSpots;
      } catch (e) {
        print('Error searching for parking spots: $e');
        return [];
      }


  }


  Future<List<ParkingSpotModel>> getAllParkingSpotsBySearchSpotId(String query) async {
    try {
      final allSpots = await getAllParkingSpots();
      // Lọc các ParkingSpotModel chứa chuỗi tìm kiếm
      final filteredSpots = allSpots
          .where((spot) => spot.spotId.toLowerCase().contains(query.toLowerCase()))
          .toList();
      // print('Filtered spots: $filteredSpots');
      return filteredSpots;
    } catch (e) {
      print('Error searching for parking spots: $e');
      return [];
    }
  }

  // them
  Future<void> updateParkingSpot({
    required String spotId,
    required int costPerHourCar,
    required int costPerHourMoto,
    required String spotName,
    required List<String> listImage,
    required GeoPoint location,
    required int occupiedMaxCar,
    required int occupiedMaxMotor,
    String? describe,
    int? star,
    int? reviewsNumber,
  }) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('ParkingSpots').doc(spotId).update({
        'spotName': spotName,
        'listImage': listImage,
        'location': location,
        'occupiedMaxCar': occupiedMaxCar,
        'occupiedMaxMotor': occupiedMaxMotor,
        'costPerHourMoto': costPerHourMoto,
        'costPerHourCar': costPerHourCar,
        'describe': describe ?? '',
        'star': star ?? 0,
        'reviewsNumber': reviewsNumber ?? 0,
      });
      print('Parking spot updated successfully.');
    } catch (e) {
      print('Error updating parking spot: $e');
    }
  }

  // Add a new parking spot to Firestore using parameters
  Future<void> addParkingSpot({
    required String spotId,
    required int costPerHourCar,
    required int costPerHourMoto,
    required String spotName,
    required List<String> listImage,
    required GeoPoint location,
    required int occupiedMaxCar,
    required int occupiedMaxMotor,
    String? describe,
    int? star,
    int? reviewsNumber,
  }) async {
    List<ParkingSpotModel> parkings = await ParkingSpotRepository().getAllParkingSpots();
    int count = parkings.length + 1 ;
    String SpotID = 'spotID${count}';
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('ParkingSpots').doc(SpotID).set({
        'spotId': SpotID,
        'spotName': spotName,
        'listImage': listImage,
        'location': location,
        'occupiedMaxCar': occupiedMaxCar,
        'occupiedMaxMotor': occupiedMaxMotor,
        'costPerHourMoto': costPerHourMoto,
        'costPerHourCar': costPerHourCar,
        'describe': describe ?? '',
        'star': star ?? 0,
        'reviewsNumber': reviewsNumber ?? 0,
      });
      print('Parking spot added successfully.');
    } catch (e) {
      print('Error adding parking spot: $e');
    }
  }

  // xoa
  Future<void> deleteParkingSpot(String spotId) async {
    try {
      await _firestore.collection('ParkingSpots').doc(spotId).delete();
      print('Parking spot deleted successfully');
    } catch (e) {
      print('Error deleting parking spot: $e');
    }
  }
}
// class ParkingSpotListWidgetBySearch extends StatefulWidget {
//   final ParkingSpotRepository parkingSpotRepository = ParkingSpotRepository();
//
//   ParkingSpotListWidgetBySearch({Key? key}) : super(key: key);
//
//   @override
//   _ParkingSpotListWidgetBySearchState createState() =>
//       _ParkingSpotListWidgetBySearchState();
// }
//
// class _ParkingSpotListWidgetBySearchState
//     extends State<ParkingSpotListWidgetBySearch> {
//   late Future<List<ParkingSpotModel>> _parkingSpotsFuture;
//   String _searchQuery = '';
//   late GoogleMapsService googleMapService;
//
//   @override
//   void initState() {
//     super.initState();
//     googleMapService = GoogleMapsService();
//     _parkingSpotsFuture = widget.parkingSpotRepository.getAllParkingSpots();
//   }
//
//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//       _parkingSpotsFuture =
//           widget.parkingSpotRepository.getAllParkingSpotsBySearch(query);
//     });
//   }
//
//   Future<double> _getDistanceFromCurrentLocation(ParkingSpotModel spot) async {
//     try {
//       // Lấy vị trí hiện tại của người dùng
//       Position currentPosition = await Geolocator.getCurrentPosition();
//       // Tính khoảng cách từ vị trí hiện tại đến vị trí đỗ xe
//       return await googleMapService.getDistanceFromCurrentLocation(
//           spot.location.latitude, spot.location.longitude);
//     } catch (e) {
//       print('Error getting distance: $e');
//       return 0;
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: TextField(
//           decoration: const InputDecoration(
//             hintText: 'Tìm kiếm vị trí đỗ xe...',
//             border: InputBorder.none,
//           ),
//           onChanged: _onSearchChanged,
//         ),
//       ),
//       body: FutureBuilder<List<ParkingSpotModel>>(
//         future: _parkingSpotsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: const CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Lỗi khi tải dữ liệu: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Không có dữ liệu'));
//           }
//
//           final parkingSpots = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: parkingSpots.length,
//             itemBuilder: (context, index) {
//               final spot = parkingSpots[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text(spot.spotName),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (spot.listImage.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Image.network(
//                             "https://drive.google.com/uc?export=view&id=${spot.listImage[0]}",
//                           ),
//                         ),
//                       Text('Mã vị trí: ${spot.spotId}'),
//                       Text('Giá/giờ xe hơi: ${spot.costPerHourCar}'),
//                       Text('Giá/giờ xe máy: ${spot.costPerHourMoto}'),
//                       Text('Số chỗ tối đa xe hơi: ${spot.OccupiedMaxCar}'),
//                       Text('Số chỗ tối đa xe máy: ${spot.OccupiedMaxMotor}'),
//                       if (spot.describe != null)
//                         Text('Mô tả: ${spot.describe}'),
//                       if (spot.star != null)
//                         Text('Đánh giá: ${spot.star} sao'),
//                       if (spot.reviewsNumber != null)
//                         Text('Số lượt đánh giá: ${spot.reviewsNumber}'),
//                       Text(
//                           'Vị trí: ${spot.location.latitude}, ${spot.location.longitude}'),
//                       FutureBuilder<double>(
//                         future: _getDistanceFromCurrentLocation(spot),
//                         builder: (context, distanceSnapshot) {
//                           if (distanceSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const CircularProgressIndicator();
//                           } else if (distanceSnapshot.hasError) {
//                             return const Text('Lỗi khi tính khoảng cách');
//                           } else if (distanceSnapshot.hasData) {
//                             return Text(
//                                 'Khoảng cách: ${distanceSnapshot.data!.toStringAsFixed(2)} km');
//                           } else {
//                             return const Text('Không thể tính khoảng cách');
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   trailing: const Icon(Icons.directions_car),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }







