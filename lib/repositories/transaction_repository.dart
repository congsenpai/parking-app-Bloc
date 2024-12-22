import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';

import '../models/transaction_model.dart';

class Income{
  double Incomes;
  double IncomeByBookingSlot; // thu nhập từ việc đặt chỗ gửi xe
  double IncomeByCommission; // thu nhập từ ăn hoa hồng < nhà phát triển >
  double IncomeByCombo; // thu nhập  từ các combo <tháng>
  double IncomeByRecharge; // thu nhập từ việc quản lý tiền nạp
  double IncomeByOther; // thu nhập  từ các nguồn khác

  Income(
      this.Incomes,
      this.IncomeByBookingSlot,
      this.IncomeByCommission,
      this.IncomeByCombo,
      this.IncomeByOther,
      this.IncomeByRecharge);
}


class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy danh sách các giao dịch dựa trên `userID`
  ///
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
  Future<List<String>> getParkingSpotRecentlyTransactionsByUser(String userID) async {
    try {
      print(userID);
      // Truy vấn collection `Transactions` với `userID` và sắp xếp theo thời gian giảm dần
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID) // Lọc theo userID
          .where('transactionType', isEqualTo: false) // Lọc theo loại giao dịch
          .orderBy('date', descending: true) // Sắp xếp giảm dần theo thời gian
          .limit(5) // Giới hạn 5 kết quả
          .get();
      print(querySnapshot.docs);
      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      Set<String> nameSpots = {}; // Set để lưu các tên không trùng lặp

      for (int i = 0; i < transactions.length; i++) {
        nameSpots.add(transactions[i].spotName);
      }


// Nếu cần danh sách thay vì Set:
      List<String> uniqueNameSpots = nameSpots.toList();

      return uniqueNameSpots;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
  Future<List<TransactionModel>> getRecentlyTransactionsByUser(String userID) async {
    try {
      print(userID);
      // Truy vấn collection `Transactions` với `userID` và sắp xếp theo thời gian giảm dần
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID)// Lọc theo loại giao dịch
          .orderBy('date', descending: true) // Sắp xếp giảm dần theo thời gian
          .limit(5) // Giới hạn 5 kết quả
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

  Future<List<TransactionModel>> getAllTransactions() async {
    try {

      // Truy vấn collection `Transactions` với `userID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
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
  Future<List<TransactionModel>> getTransactionsByNameSpot(String spotName) async {
    try {
      final allSpots = await getAllTransactions();
      // Lọc các ParkingSpotModel chứa chuỗi tìm kiếm
      final filteredSpots = allSpots
          .where((spot) => spot.spotName.toLowerCase().contains(spotName.toLowerCase()))
          .toList();
      print('Filtered spots: $filteredSpots');
      return filteredSpots;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
  Future<List<TransactionModel>> get10RecentTransactions() async {
    try {
      // Truy vấn collection `Transactions` với `userID`, sắp xếp theo `transactionID` giảm dần
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .orderBy('transactionID', descending: true) // Sắp xếp theo transactionID giảm dần
          .limit(10) // Giới hạn chỉ lấy 10 giao dịch
          .get();

      // print(querySnapshot.docs);

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
  // Lấy ra doanh thu từ toàn bộ các giao dịch
  Future<Income?> getIncomefromTransactionsAll() async {
    try {

      // Truy vấn collection `Transactions` với `userID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .get();
      // print(querySnapshot.docs);

      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      double IncomeByBookingSlot = 0; // thu nhập từ việc đặt chỗ gửi xe
      double IncomeByCommission = 0; // thu nhập từ ăn hoa hồng < nhà phát triển >
      double IncomeByCombo = 0; // thu nhập  từ các combo <tháng>
      double IncomeByRecharge = 0; // thu nhập từ việc quản lý tiền nạp
      double IncomeByOther  = 0;
      double Incomes =0;
      for(int i =0;i<transactions.length;i++){
        Incomes = Incomes + transactions[i].total;
        if(transactions[i].transactionType == true){
          IncomeByRecharge = IncomeByRecharge + transactions[i].total;
        }
        else {
          IncomeByBookingSlot = IncomeByBookingSlot + transactions[i].total;
        }
      }
      IncomeByCommission = IncomeByBookingSlot *0.2;
      Income income = Income(Incomes, IncomeByBookingSlot, IncomeByCommission, IncomeByCombo, IncomeByOther, IncomeByRecharge);
      return income;


    } catch (e) {
      print('Error fetching transactions: $e');
    }
    return null;
  }
  Future<Income?> getIncomefromTransactionsBySpotName(spotID) async {
    try {
      List<ParkingSpotModel> spots = await ParkingSpotRepository().getAllParkingSpotsBySearchSpotId(spotID);
      String SpotName = spots[0].spotName;

      // Truy vấn collection `Transactions` với `userID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions')
          .where('spotName', isEqualTo: SpotName)
          .where('transactionType', isEqualTo: false)
      // Tên collection trong Firestore
          .get();
      // print(querySnapshot.docs);

      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      double IncomeByBookingSlot = 0; // thu nhập từ việc đặt chỗ gửi xe
      double IncomeByCommission = 0; // thu nhập từ ăn hoa hồng < nhà phát triển >
      double IncomeByCombo = 0; // thu nhập  từ các combo <tháng>
      double IncomeByRecharge = 0; // thu nhập từ việc quản lý tiền nạp
      double IncomeByOther  = 0;
      double Incomes =0;
      for(int i =0;i<transactions.length;i++){
        Incomes = Incomes + transactions[i].total;
        if(transactions[i].transactionType == true){
          IncomeByRecharge = IncomeByRecharge + transactions[i].total;
        }
        else {
          IncomeByBookingSlot = IncomeByBookingSlot + transactions[i].total;
        }
      }
      IncomeByCommission = IncomeByBookingSlot *0.2;
      Income income = Income(Incomes, IncomeByBookingSlot, IncomeByCommission, IncomeByCombo, IncomeByOther, IncomeByRecharge);
      return income;


    } catch (e) {
      print('Error fetching transactions: $e');
    }
    return null;
  }



}
