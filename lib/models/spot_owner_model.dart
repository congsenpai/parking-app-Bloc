import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl_phone_field/phone_number.dart';

class SpotOwnerModel {
  final String spotOwnerID;
  final String spotOwnerName;
  final String constractURL;
  final bool isActive;
  final Timestamp createdTime;
  final String spotID;
  final String phoneNumber;

  SpotOwnerModel( {
    required this.spotOwnerID,
    required this.isActive,
    required this.constractURL,
    required this.createdTime,
    required this.spotOwnerName,
    required this.spotID,
    required this.phoneNumber,
  });

  // Convert Firestore JSON to SpotOwnerModel
  factory SpotOwnerModel.fromJson(Map<String, dynamic> json) {
    return SpotOwnerModel(
      phoneNumber: json['phoneNumber'] ?? '',
      spotOwnerID: json['spotOwnerID'] ?? '',
      spotOwnerName: json['spotOwnerName'] ?? '',
      constractURL: json['constractURL'] ?? '',
      isActive: json['isActive'] ?? '',
      createdTime: json['createdTime'] as Timestamp,
      spotID: json['spotID'] as String,
    );
  }

  // Convert SpotOwnerModel to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber' : phoneNumber,
      'spotOwnerID': spotOwnerID,
      'spotOwnerName': spotOwnerName,
      'constractURL': constractURL,
      'isActive': isActive,
      'createdTime': createdTime,
      'spotID': spotID,
    };
  }
}
