class SpotSlotsModel {
  final Map<String, int> carSlots;
  final Map<String, int> motoSlots;
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
      spotID: json['spotID'],
      spotName: json['spotName'],
      carSlots: Map<String, int>.from(json['carSlots'] ?? {}),
      motoSlots: Map<String, int>.from(json['motoSlots'] ?? {}),
    );
  }

  /// Phương thức để chuyển đối tượng `SpotSlotsModel` thành `Map<String, dynamic>`
  Map<String, dynamic> toMap() {
    return {
      'carSlots': carSlots,
      'motoSlots': motoSlots,
      'spotID': spotID,
      'spotName': spotName,
    };
  }
}
