// ignore_for_file: non_constant_identifier_names, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
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
class ConsumptionByDay{
  int year;
  int month;
  List<FlSpot> Up_flspots;
  List<FlSpot> Down_flspots;

  ConsumptionByDay(
      this.month,this.year,this.Down_flspots,this.Up_flspots
      );
}
class ConsumptionByMonth{
  int year;
  List<FlSpot> Up_flspots;
  List<FlSpot> Down_flspots;
  ConsumptionByMonth(
      this.year,
      this.Up_flspots,
      this.Down_flspots);
}
class TransactionTime{
  int year;
  int month;
  int day;
  double budget;
  bool TransactionType;
  TransactionTime(
      this.year,this.month,this.day,this.budget,this.TransactionType
      );
}

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy danh sách các giao dịch dựa trên `userID`
  ///
  Future<List<TransactionModel>> getTransactionsByUser(String userID) async {
    try {
      // Truy vấn collection `Transactions` với `userID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID) // Lọc với userID
          .get();

      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return transactions;
    } catch (e) {
      return [];
    }
  }
  Future<List<TransactionTime>> getTimeAndTypeOfTransactionByUserID(String userID) async{
    try{
      final trans = await getTransactionsByUser(userID);
      List<TransactionTime> transactionTimes = [];
      for(var tran in trans){
        int year = tran.date.toDate().year;
        int month = tran.date.toDate().month;
        int day = tran.date.toDate().day;
        double budget = tran.total;
        bool TransactionType = tran.transactionType;
        TransactionTime transactionTime = TransactionTime(year, month, day, budget, TransactionType);
        transactionTimes.add(transactionTime);
      }
      return transactionTimes;
    }
    catch(e){
      return [];
    }
  }
  Future<List<ConsumptionByMonth>> getlistTransactionOfCustomerbyUserID(String userID) async {
    try {
      // Lấy danh sách giao dịch đã được xử lý từ getTimeAndTypeOfTransactionByUserID
      final transactionTimes = await getTimeAndTypeOfTransactionByUserID(userID);

      // Map để lưu tổng doanh thu theo năm và tháng, chia theo TransactionType (Up/Down)
      Map<int, Map<int, double>> upYearToMonthlyTotal = {}; // Lưu tổng theo năm và tháng (Up)
      Map<int, Map<int, double>> downYearToMonthlyTotal = {}; // Lưu tổng theo năm và tháng (Down)

      // Nhóm các giao dịch theo năm, tháng và TransactionType (Up hoặc Down)
      for (var transaction in transactionTimes) {
        int year = transaction.year;
        int month = transaction.month;

        if (transaction.TransactionType) { // Up transaction type (true)
          upYearToMonthlyTotal.putIfAbsent(year, () => {});
          upYearToMonthlyTotal[year]![month] =
              (upYearToMonthlyTotal[year]![month] ?? 0) + transaction.budget;
        } else { // Down transaction type (false)
          downYearToMonthlyTotal.putIfAbsent(year, () => {});
          downYearToMonthlyTotal[year]![month] =
              (downYearToMonthlyTotal[year]![month] ?? 0) + transaction.budget;
        }
      }
      // Tạo danh sách các đối tượng ConsumptionByMonth
      List<ConsumptionByMonth> cons = [];

      // Duyệt qua cả upYearToMonthlyTotal và downYearToMonthlyTotal
      Set<int> allYears = {
        ...upYearToMonthlyTotal.keys,
        ...downYearToMonthlyTotal.keys
      };

      for (var year in allYears) {
        // Lấy dữ liệu Up cho năm hiện tại (nếu có)
        List<FlSpot> upFlSpots = upYearToMonthlyTotal[year]?.entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList() ??
            [];

        // Lấy dữ liệu Down cho năm hiện tại (nếu có)
        List<FlSpot> downFlSpots = downYearToMonthlyTotal[year]?.entries
            .map((e) => FlSpot(e.key.toDouble(), e.value))
            .toList() ??
            [];

        // Thêm ConsumptionByMonth vào danh sách
        cons.add(ConsumptionByMonth(year, upFlSpots, downFlSpots));
      }


      return cons; // Trả về danh sách ConsumptionByMonth
    } catch (e) {
      return [];
    }
  }

  Future<List<ConsumptionByDay>> getlistTransactionOfCustomerByDay(String userID) async {
    try {
      // Lấy dữ liệu giao dịch và chuyển thành danh sách TransactionTime
      final transactionTimes = await getTimeAndTypeOfTransactionByUserID(userID);
      List<ConsumptionByDay> consByDay = [];

      // Map lưu tổng ngân sách theo năm, tháng, ngày và TransactionType (Up/Down)
      Map<int, Map<int, Map<int, double>>> upYearToDailyTotal = {}; // Lưu doanh thu (Up)
      Map<int, Map<int, Map<int, double>>> downYearToDailyTotal = {}; // Lưu doanh thu (Down)

      // Nhóm dữ liệu theo năm, tháng, ngày và TransactionType
      for (var transaction in transactionTimes) {
        int year = transaction.year;
        int month = transaction.month;
        int day = transaction.day;

        if (transaction.TransactionType) { // TransactionType = true (Up)
          upYearToDailyTotal.putIfAbsent(year, () => {});
          upYearToDailyTotal[year]!.putIfAbsent(month, () => {});
          upYearToDailyTotal[year]![month]![day] =
              (upYearToDailyTotal[year]![month]![day] ?? 0) + transaction.budget;
        } else { // TransactionType = false (Down)
          downYearToDailyTotal.putIfAbsent(year, () => {});
          downYearToDailyTotal[year]!.putIfAbsent(month, () => {});
          downYearToDailyTotal[year]![month]![day] =
              (downYearToDailyTotal[year]![month]![day] ?? 0) + transaction.budget;
        }
      }
      // Tạo tập hợp tất cả các năm và tháng để xử lý
      Set<int> allYears = {
        ...upYearToDailyTotal.keys,
        ...downYearToDailyTotal.keys
      };

      for (var year in allYears) {
        Set<int> allMonths = {
          ...upYearToDailyTotal[year]?.keys ?? {},
          ...downYearToDailyTotal[year]?.keys ?? {}
        };

        for (var month in allMonths) {
          // Lấy danh sách FlSpot cho Up
          List<FlSpot> upFlSpots = upYearToDailyTotal[year]?[month]?.entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList() ??
              [];

          // Lấy danh sách FlSpot cho Down
          List<FlSpot> downFlSpots = downYearToDailyTotal[year]?[month]?.entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList() ??
              [];

          // Thêm vào danh sách ConsumptionByDay
          consByDay.add(ConsumptionByDay(month, year, downFlSpots, upFlSpots));
        }
      }

      return consByDay; // Trả về danh sách ConsumptionByDay
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getParkingSpotRecentlyTransactionsByUser(String userID) async {
    try {
      // Truy vấn collection `Transactions` với `userID` và sắp xếp theo thời gian giảm dần
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID) // Lọc theo userID
          .where('transactionType', isEqualTo: false) // Lọc theo loại giao dịch
          .orderBy('date', descending: true) // Sắp xếp giảm dần theo thời gian
          .limit(5) // Giới hạn 5 kết quả
          .get();
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
      return [];
    }
  }
  Future<List<TransactionModel>> getRecentlyTransactionsByUser(String userID) async {
    try {
      // Truy vấn collection `Transactions` với `userID` và sắp xếp theo thời gian giảm dần
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID)// Lọc theo loại giao dịch
          .orderBy('date', descending: true) // Sắp xếp giảm dần theo thời gian
          .limit(5) // Giới hạn 5 kết quả
          .get();
      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return transactions;
    } catch (e) {
      return [];
    }
  }
  Future<List<TransactionModel>> getAllRecentlyTransactionsByUser(String userID) async {
    try {
      // Truy vấn collection `Transactions` với `userID` và sắp xếp theo thời gian giảm dần
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .where('userID', isEqualTo: userID)// Lọc theo loại giao dịch
          .orderBy('date', descending: true) // Sắp xếp giảm dần theo thời gian
          .get();
      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return transactions;
    } catch (e) {
      return [];
    }
  }
  Future<List<TransactionModel>> getAllTransactions() async {
    try {

      // Truy vấn collection `Transactions` với `userID`
      QuerySnapshot querySnapshot = await _firestore
          .collection('Transactions') // Tên collection trong Firestore
          .get();

      // Chuyển đổi danh sách `QueryDocumentSnapshot` thành danh sách `TransactionModel`
      List<TransactionModel> transactions = querySnapshot.docs
          .map((doc) => TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return transactions;
    } catch (e) {
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
      return filteredSpots;
    } catch (e) {
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
      return [];
    }
  }
  Future<TransactionModel?> getTransactionsByID(String transactionID) async {
    try {
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
        return null; // Không tìm thấy giao dịch
      }
    } catch (e) {
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
    } catch (e) {
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
    }
    return null;
  }
}
