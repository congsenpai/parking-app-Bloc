import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../models/spot_owner_model.dart';

class SpotOwnerRepository{
  Future<List<SpotOwnerModel>> getAllSpotOwners() async {
    final firestore = FirebaseFirestore.instance;
    List<SpotOwnerModel> owners = [];

    try {
      QuerySnapshot snapshot = await firestore.collection('SpotOwners').get();
      owners = snapshot.docs.map((doc) {
        return SpotOwnerModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      print('Fetched all spot owners successfully.');
    } catch (e) {
      print('Error fetching all spot owners: $e');
    }

    return owners;
  }
  Future<List<SpotOwnerModel>> getSpotOwnersByName(String spotOwner) async {
    try {
      final allOwners = await getAllSpotOwners();
      // Lọc các ParkingSpotModel chứa chuỗi tìm kiếm
      final filteredOwners= allOwners
          .where((owner) => owner.spotOwnerName.toLowerCase().contains(spotOwner.toLowerCase()))
          .toList();
      print('Filtered spots: $filteredOwners');
      return filteredOwners;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
  Future<SpotOwnerModel?> loginByOwner(String phone, String passWord) async {
    try {
      final allOwners = await getAllSpotOwners();

      // Tìm người dùng khớp với phone và password
      final matchingOwner = allOwners.firstWhere(
            (owner) =>
        owner.phoneNumber.toLowerCase() == phone.toLowerCase() &&
            owner.passWord == passWord, // Trả về null nếu không tìm thấy
      );

      print('Matched owner: $matchingOwner');
      return matchingOwner;
    } catch (e) {
      print('Error fetching owners: $e');
      return null; // Trả về null nếu xảy ra lỗi
    }
  }


  // Hàm thêm mới SpotOwner vào Firestore
  Future<void> addSpotOwner({

    required String spotOwnerName,
    required String constractURL,
    required bool isActive,
    required Timestamp createdTime,
    required String spotID,
    required PhoneNumber phoneNumber,
    required bool isAdmin,
  }) async {

    final firestore = FirebaseFirestore.instance;

    try {
      final snapshot = await firestore.collection('SpotOwners').get();
      int count = snapshot.docs.length +1 ;
      String spotOwnerID = 'spotOwnerID${count}';


      await firestore.collection('SpotOwners').doc(spotOwnerID).set({
        'spotOwnerID': spotOwnerID,
        'spotOwnerName': spotOwnerName,
        'constractURL': constractURL,
        'isActive': isActive,
        'createdTime': createdTime,
        'spotID': spotID,
        'PhoneNumber': PhoneNumber,
      });
      print('Spot owner added successfully.');
    } catch (e) {
      print('Error adding spot owner: $e');
    }
  }

  // Hàm cập nhật trạng thái `isActive` theo ID
  static Future<void> updateSpotOwnerStatus(String spotOwnerID, bool newStatus) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('SpotOwners').doc(spotOwnerID).update({
        'isActive': newStatus,
      });
      print('Spot owner status updated successfully.');
    } catch (e) {
      print('Error updating spot owner status: $e');
    }
  }
}
