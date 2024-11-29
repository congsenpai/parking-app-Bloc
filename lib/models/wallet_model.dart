import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  final String walletCode; // Mã ví
  final String userID; // ID người dùng
  final String userName; // Tên người dùng
  final double balance; // Số dư ví
  final double creditScore; // Điểm tín dụng
  final bool isAction; // Trạng thái kích hoạt ví
  final Timestamp createdOn; // Thời gian tạo ví

  WalletModel({
    required this.walletCode,
    required this.userID,
    required this.userName,
    required this.balance,
    required this.creditScore,
    required this.isAction,
    required this.createdOn,
  });

  /// Convert WalletModel to Map for Firestore or JSON encoding
  Map<String, dynamic> toJson() {
    return {
      'walletCode': walletCode,
      'userID': userID,
      'userName': userName,
      'balance': balance,
      'creditScore': creditScore,
      'isAction': isAction,
      'createdOn': createdOn,
    };
  }

  /// Create WalletModel from Map (Firestore document snapshot)
  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletCode: json['walletCode'] as String,
      userID: json['userID'] as String,
      userName: json['userName'] as String,
      balance: (json['balance'] as num).toDouble(),
      creditScore: (json['creditScore'] as num).toDouble(),
      isAction: json['isAction'] as bool,
      createdOn: json['createdOn'] as Timestamp, // Ensure proper type
    );
  }
}
