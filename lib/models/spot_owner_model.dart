import 'package:cloud_firestore/cloud_firestore.dart';


class SpotOwnerModel {
  final String spotOwnerID;
  final String spotOwnerName;
  final String constractURL;
  final bool isActive;
  final Timestamp createdTime;
  final String spotID;
  final String phoneNumber;
  final bool isAdmin;
  final String passWord;


  SpotOwnerModel( {
    required this.spotOwnerID,
    required this.isActive,
    required this.constractURL,
    required this.createdTime,
    required this.spotOwnerName,
    required this.spotID,
    required this.phoneNumber,
    required this.isAdmin,
    required this.passWord
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
      isAdmin: json['isAdmin'] as bool,
      passWord: json['passWord'] as String
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
      'isAdmin': isAdmin,
      'passWord':passWord
    };
  }
}
