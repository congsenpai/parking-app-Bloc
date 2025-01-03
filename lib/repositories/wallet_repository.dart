// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_smart_parking_app/models/wallet_model.dart';

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<WalletModel?> getWallet(String userID) async {
    try {
      // Access the document based on userID
      DocumentSnapshot snapshot = await _firestore
          .collection('Wallet')
          .doc(userID)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        // Convert DocumentSnapshot data to WalletModel
        final Map<String, dynamic> data =
        snapshot.data() as Map<String, dynamic>;
        final WalletModel walletData = WalletModel.fromJson(data);
        return walletData;
      } else {
        print('Wallet not found for userID: $userID');
        return null;
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
      return null;
    }
  }
  Future<void> addWallet(String userID, WalletModel walletData) async {
    try {
      // Thêm tài liệu Wallet cho userID
      await _firestore.collection('Wallet').doc(userID).set(walletData.toJson());
      print('Wallet added for userID: $userID');
    } catch (e) {
      print('Error adding wallet: $e');
    }
  }
  Future<void> deleteWallet(String userID) async {
    try {
      // Xóa tài liệu Wallet cho userID
      await _firestore.collection('Wallet').doc(userID).delete();
      print('Wallet deleted for userID: $userID');
    } catch (e) {
      print('Error deleting wallet: $e');
    }
  }
  Future<void> updateWalletBalance(String userID, double newBalance) async {
    try {
      double? bal = await getBalanceByUserID(userID);

      // Truy cập tài liệu của Wallet dựa trên userID và cập nhật budget
      await _firestore.collection('Wallet').doc(userID).update({
        'balance': newBalance+bal!,
      });
      print('Wallet budget updated for userID: $userID');
    } catch (e) {
      print('Error updating wallet budget: $e');
    }
  }
  Future<double?> getBalanceByUserID(String userID) async {
    try {

      // Truy cập tài liệu của Wallet theo userID
      DocumentSnapshot snapshot = await _firestore
          .collection('Wallet')
          .doc(userID)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        // Chuyển đổi dữ liệu thành Map và lấy ra giá trị của budget
        final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        double balance =  (data['balance'] is int) ? (data['balance'] as int).toDouble() : data['balance'] ?? 0.0;

        return balance;
      } else {
        print('No wallet found for userID: $userID');
        return null;
      }
    } catch (e) {
      print('Error fetching budget: $e');
      return null;
    }
  }




}
