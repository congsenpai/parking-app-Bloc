// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSpotModel {
  final String spotId;
  final int costPerHourCar;
  final int costPerHourMoto;
  final String spotName;
  final List<String> listImage;
  final GeoPoint location;
  final int OccupiedMaxCar;
  final int OccupiedMaxMotor;
  final String? describe;
  final int? star;
  final int? reviewsNumber;

  ParkingSpotModel({
    required this.spotId,
    required this.costPerHourCar,
    required this.costPerHourMoto,
    required this.spotName,
    required this.listImage,
    required this.location,
    required this.OccupiedMaxCar,
    required this.OccupiedMaxMotor,
    required this.star,
    required this.describe,
    required this.reviewsNumber,
  });

  // Phương thức này chuyển đổi đối tượng ParkingSpotModel thành Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'spotId': spotId,
      'spotName': spotName,
      'listImage': listImage,
      'location': location,
      'OccupiedMaxCar': OccupiedMaxCar,
      'OccupiedMaxMotor': OccupiedMaxMotor,
      'costPerHourMoto': costPerHourMoto,
      'costPerHourCar': costPerHourCar,
      'describe': describe,
      'star': star,
      'reviewsNumber': reviewsNumber,
    };
  }
  // Phương thức này khởi tạo đối tượng ParkingSpotModel từ một Map<String, dynamic>
  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSpotModel(
      spotId: json['spotID'] ?? 'Unknown Spot ID',  // Sử dụng giá trị mặc định
      spotName: json['spotName'] ?? 'Unnamed Spot', // Sử dụng giá trị mặc định
      listImage: List<String>.from(json['listImage'] ?? []), // Nếu không có ảnh, gán danh sách rỗng
      location: json['location'] != null ? json['location'] as GeoPoint : GeoPoint(0, 0), // Kiểm tra location
      OccupiedMaxCar: json['OccupiedMaxCar'] ?? 0, // Giá trị mặc định nếu là null
      OccupiedMaxMotor: json['OccupiedMaxMotor'] ?? 0, // Giá trị mặc định nếu là null
      describe: json['describe'] ?? '', // Gán giá trị mặc định nếu là null
      costPerHourMoto: json['costPerHourMoto'] ?? 0, // Giá trị mặc định nếu là null
      costPerHourCar: json['costPerHourCar'] ?? 0, // Giá trị mặc định nếu là null
      star: json['star'] ?? 0, // Giá trị mặc định nếu là null
      reviewsNumber: json['reviewsNumber'] ?? 0, // Giá trị mặc định nếu là null
    );
  }
}
