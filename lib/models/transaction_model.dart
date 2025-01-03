import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String note; // Ghi chú
  final String typeVehical; // Loại phương tiện
  final double budget; // Ngân sách
  final Timestamp date; // Ngày tạo giao dịch
  final Timestamp endTime; // Thời gian kết thúc
  final String slotName; // Tên chỗ đỗ
  final String spotName; // Tên điểm đỗ xe
  final Timestamp startTime; // Thời gian bắt đầu
  final double total; // Tổng chi phí
  final double totalTime; // Tổng thời gian
  final double transactionID; // ID giao dịch
  final bool transactionType; // Loại giao dịch (true: thanh toán thành công)
  final String userID; // ID người dùng
  final String vehicalLicense;

  TransactionModel({
    required this.vehicalLicense,
    required this.note,
    required this.typeVehical,
    required this.budget,
    required this.date,
    required this.endTime,
    required this.slotName,
    required this.spotName,
    required this.startTime,
    required this.total,
    required this.totalTime,
    required this.transactionID,
    required this.transactionType,
    required this.userID,
  });
  /// Tạo `TransactionModel` từ `Map` (Firestore JSON)
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      vehicalLicense : json['vehicalLicense'] as String,
      note: json['Note'] as String,
      typeVehical: json['TypeVehical'] as String,
      date: json['date'] as Timestamp,
      endTime: json['endTime'] as Timestamp,
      slotName: json['slotName'] as String,
      spotName: json['spotName'] as String,
      startTime: json['startTime'] as Timestamp,
      transactionID: (json['transactionID'] is int) ? (json['transactionID'] as int).toDouble() :
      json['transactionID'] as double,
      transactionType: json['transactionType'] as bool,
      userID: json['userID'] as String,
      total: (json['total'] is int) // Kiểm tra kiểu int và chuyển sang double
          ? (json['total'] as int).toDouble()
          : json['total'] as double,
      budget: (json['budget'] is int)
          ? (json['budget'] as int).toDouble()
          : json['budget'] as double,
      totalTime: (json['totalTime'] is int)
          ? (json['totalTime'] as int).toDouble()
          : json['totalTime'] as double,
    );
  }

  /// Chuyển `TransactionModel` thành Map (Firestore JSON)
  Map<String, dynamic> toJson() {
    return {
      'vehicalLicense': vehicalLicense,
      'Note': note,
      'TypeVehical': typeVehical,
      'budget': budget,
      'date': date,
      'endTime': endTime,
      'slotName': slotName,
      'spotName': spotName,
      'startTime': startTime,
      'total': total,
      'totalTime': totalTime,
      'transactionID': transactionID,
      'transactionType': transactionType,
      'userID': userID,
    };
  }
}
