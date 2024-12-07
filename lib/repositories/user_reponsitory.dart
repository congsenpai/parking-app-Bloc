import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction_model.dart';
import '../models/user_model.dart';


class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /// Lấy danh sách các giao dịch dựa trên `userID`
  Future<UserModel?> getUserByID(String userID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();
      if(snapshot.exists){
        UserModel userModel = UserModel.fromJson(snapshot.data()!);
        return userModel;
      }
      else{
        print('User with ID $userID does not exist.');
        return null;
      }
    } catch (e) {
      print('User with ID $userID does not exist.');
      return null;
    }
  }
  Future<void> updateUserByID(
      String userID,
      String userName,
      String email,
      String phone,
      String userImg,
      String country,
      String userAddress,
      List<Map<String, String>> vehical,
      ) async {
    try {
      // Tham chiếu tới tài liệu trong Firestore
      DocumentReference docRef =
      FirebaseFirestore.instance.collection('users').doc(userID);

      // Dữ liệu cập nhật
      Map<String, dynamic> updatedData = {
        'username': userName,
        'email': email,
        'phone': phone,
        'userImg': userImg,
        'country': country,
        'userAddress': userAddress,
        'vehical': vehical,
      };
      // Cập nhật thông tin trong Firestore
    } catch (e) {
      print('Lỗi khi cập nhật thông tin người dùng: $e');
    }

  }

}
