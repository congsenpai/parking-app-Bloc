import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';


class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy danh sách các giao dịch dựa trên `userID`
  Future<List<TransactionModel>> getTransactionsByUser(String userID) async {
    try {
      print(userID);
      // Truy vấn collection `Transactions` với `userID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID) // Lọc với userID
          .get();
      print(querySnapshot.docs);

      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
}
