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
  Future<TransactionModel?> getTransactionsByID(String transactionID) async {
    try {
      print('Transaction ID: $transactionID');


      // Chuyển đổi transactionID từ String sang int nếu cần thiết
      // Chuyển đổi từ String sang double trước
      double parsedDouble = double.tryParse(transactionID) ?? 0.0;

// Chuyển đổi từ double sang int
      int parsedTransactionID = parsedDouble.toInt();

      // Truy vấn collection `Transactions` với `transactionID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions')
          .where('transactionID', isEqualTo: parsedTransactionID) // So khớp giá trị
          .get();

      // Kiểm tra nếu có kết quả trả về
      if (querySnapshot.docs.isNotEmpty) {
        // Lấy tài liệu đầu tiên từ danh sách kết quả
        final TransactionModel transaction = TransactionModel.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
        return transaction; // Trả về kết quả
      } else {
        print('No transaction found with this ID');
        return null; // Không tìm thấy giao dịch
      }
    } catch (e) {
      print('Error fetching transactions by id: $e');
      return null; // Trả về null trong trường hợp lỗi
    }
  }


  // Phương thức thêm giao dịch vào Firestore
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Transactions').get();

      // Tăng giá trị transactionCount lên 1
      double transactionCount = snapshot.size + 1;


      // Sử dụng transactionCount làm ID cho document mới
      await _firestore.collection('Transactions').doc(transactionCount.toString()).set({
        'transactionID': transactionCount,
        'vehicalLicense': transaction.vehicalLicense,
        'Note': transaction.note,
        'TypeVehical': transaction.typeVehical,
        'budget': transaction.budget,
        'date': transaction.date,
        'endTime': transaction.endTime,
        'slotName': transaction.slotName,
        'spotName': transaction.spotName,
        'startTime': transaction.startTime,
        'total': transaction.total,
        'totalTime': transaction.totalTime,
        'transactionType': transaction.transactionType,
        'userID': transaction.userID,
      });
      print('Transaction added successfully000');
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

}
