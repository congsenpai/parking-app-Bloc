class SpotSlotsModel {
  final Map<String, bool> carSlots;
  final Map<String, bool> motoSlots;
  final String spotID;
  final String spotName;

  SpotSlotsModel({
    required this.carSlots,
    required this.motoSlots,
    required this.spotID,
    required this.spotName,
  });

  /// Phương thức khởi tạo `SpotSlotsModel` từ `Map<String, dynamic>`
  factory SpotSlotsModel.fromJson(Map<String, dynamic> json) {
    return SpotSlotsModel(
      spotID: json['SpotID'] ?? '',
      spotName: json['SpotName'] ?? '',
      carSlots: Map<String, bool>.from(json['carSlots'] ?? {}),
      motoSlots: Map<String, bool>.from(json['motoSlots'] ?? {}),
    );
  }

  /// Phương thức để chuyển đối tượng `SpotSlotsModel` thành `Map<String, dynamic>`
  Map<String, dynamic> toMap() {
    return {
      'carSlots': carSlots,
      'motoSlots': motoSlots,
      'SpotID': spotID,
      'SpotName': spotName,
    };
  }
}
