import 'package:cloud_firestore/cloud_firestore.dart';


class ParkingBookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getVehicalLicense(String userID) async {
    List<String> vehicalLicense = [];
    try {
      // Truy cập vào document hoặc subcollection dựa trên userID
      DocumentSnapshot snapshot = await _firestore
          .collection('ParkingSpots')
          .doc(userID)
          .get();

      if (snapshot.exists) {
        // Giả sử dữ liệu chứa danh sách biển số trong một field "licenses"
        List<dynamic> licenses = snapshot.get('licenses') ?? [];
        vehicalLicense = licenses.cast<String>();
      }
    } catch (e) {
      print('Error fetching vehicle licenses: $e');
    }
    return vehicalLicense;
  }
}
