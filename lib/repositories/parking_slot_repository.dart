import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot_model.dart';

class ParkingSlotData {
  final List<String> occupiedSlotsCar;
  final List<String> occupiedSlotsMoto;
  final List<String> parkingSectionCar;
  final List<String> parkingSectionMoto;
  final String spotName;
  final String spotID;

  ParkingSlotData({
    required this.occupiedSlotsCar,
    required this.occupiedSlotsMoto,
    required this.parkingSectionCar,
    required this.parkingSectionMoto,
    required this.spotID,
    required this.spotName,
  });
}

Future<ParkingSlotData?> fetchSpotSlot(String documentId) async {
  try {
    print('Fetching document: $documentId');

    // Lấy document từ Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('ParkingSlots')
        .doc(documentId)
        .get();

    if (snapshot.exists) {
      // Chuyển dữ liệu sang SpotSlotsModel
      SpotSlotsModel spotSlot = SpotSlotsModel.fromJson(snapshot.data()!);

      // Chuẩn bị dữ liệu
      List<String> occupiedSlotsCar = [];
      List<String> occupiedSlotsMoto = [];
      List<String> parkingSectionCar = [];
      List<String> parkingSectionMoto = [];

      // Xử lý car slots
      spotSlot.carSlots.forEach((key, value) {
        parkingSectionCar.add(key);
        if (!value) {
          occupiedSlotsCar.add(key);
        }
      });

      // Xử lý moto slots
      spotSlot.motoSlots.forEach((key, value) {
        parkingSectionMoto.add(key);
        if (!value) {
          occupiedSlotsMoto.add(key);
        }
      });

      // In thông tin kiểm tra
      print("Occupied Car Slots: $occupiedSlotsCar");
      print("Occupied Moto Slots: $occupiedSlotsMoto");
      print("Parking Section Car: $parkingSectionCar");
      print("Parking Section Moto: $parkingSectionMoto");

      // Trả về đối tượng ParkingSlotData
      return ParkingSlotData(
        occupiedSlotsCar: occupiedSlotsCar,
        occupiedSlotsMoto: occupiedSlotsMoto,
        parkingSectionCar: parkingSectionCar,
        parkingSectionMoto: parkingSectionMoto,
        spotID: spotSlot.spotID,
        spotName: spotSlot.spotName,
      );
    } else {
      print("Document không tồn tại.");
      return null;
    }
  } catch (e) {
    print("Lỗi khi lấy dữ liệu: $e");
    return null;
  }
}
