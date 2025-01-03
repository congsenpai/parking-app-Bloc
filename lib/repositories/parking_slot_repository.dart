// ignore_for_file: body_might_complete_normally_nullable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot_model.dart';
class ParkingSlotData {
  // danh sach vị trí bị chiếm ( đã có xe )
  final List<String> occupiedSlotsCar;
  final List<String> occupiedSlotsMoto;
  // danh sach vị trí chưa đặt
  final List<String> parkingSectionCar;
  final List<String> parkingSectionMoto;
  // danh sách vị trí đã được order nhưng xe chưa di chuyển đến
  final List<String> bookingReservationCar;
  final List<String> bookingReservationMoto;
  final String spotName;
  final String spotID;
  ParkingSlotData({
    required this.occupiedSlotsCar,
    required this.occupiedSlotsMoto,
    required this.parkingSectionCar,
    required this.parkingSectionMoto,
    required this.spotID,
    required this.spotName,
    required this.bookingReservationCar,
    required this.bookingReservationMoto,
  });
}

/*
0 : chưa có xe đỗ
1 : có nhưng xe chưa đến
2 : có và xe đã đến chỗ
 */
Future<ParkingSlotData?> fetchSpotSlot(String documentId) async {
  try {
    //print('Fetching document: $documentId');
    // Lấy document từ Firestore
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('ParkingSlots')
        .doc(documentId)
        .get();
    if (snapshot.exists) {
      // Chuyển dữ liệu sang SpotSlotsModel
      SpotSlotsModel spotSlot = SpotSlotsModel.fromJson(snapshot.data()!);
      // print(spotSlot);
      String spotName = spotSlot.spotName;
      // print(spotSlot.spotName);
      // print(spotSlot.spotID);
      String spotID = spotSlot.spotID;
      // Chuẩn bị dữ liệu
      List<String> occupiedSlotsCar = [];
      List<String> occupiedSlotsMoto = [];
      List<String> parkingSectionCar = [];
      List<String> parkingSectionMoto = [];
      List<String> bookingReservationCar = [];
      List<String> bookingReservationMoto = [];
      // Xử lý car slots
      spotSlot.carSlots.forEach((key, value) {
        parkingSectionCar.add(key);
        if (value == 2) {
          occupiedSlotsCar.add(key);
        }
        else{if(value == 1){
          bookingReservationCar.add(key);
        }}
      });
      // Xử lý moto slots
      spotSlot.motoSlots.forEach((key, value) {
        parkingSectionMoto.add(key);
        if (value == 2) {
          occupiedSlotsMoto.add(key);
        }
        else {
          if (value == 1) {
            bookingReservationMoto.add(key);
          }
        }
      });
      parkingSectionCar.sort((a, b) {
        // Tách chữ và số từ tên slot
        final letterA = a[0];
        final letterB = b[0];

        // Lấy số từ tên slot
        final numberA = int.parse(RegExp(r'\d+').stringMatch(a)!);
        final numberB = int.parse(RegExp(r'\d+').stringMatch(b)!);

        // So sánh theo chữ cái trước
        if (letterA != letterB) {
          return letterA.compareTo(letterB);
        }

        // Nếu chữ cái giống nhau, so sánh theo số
        return numberA.compareTo(numberB);
      });
      parkingSectionMoto.sort((a, b) {
        // Tách chữ và số từ tên slot
        final letterA = a[0];
        final letterB = b[0];

        // Lấy số từ tên slot
        final numberA = int.parse(RegExp(r'\d+').stringMatch(a)!);
        final numberB = int.parse(RegExp(r'\d+').stringMatch(b)!);

        // So sánh theo chữ cái trước
        if (letterA != letterB) {
          return letterA.compareTo(letterB);
        }

        // Nếu chữ cái giống nhau, so sánh theo số
        return numberA.compareTo(numberB);
      });
      // In thông tin kiểm tra
      // print("Occupied Car Slots: $occupiedSlotsCar");
      // print("Occupied Moto Slots: $occupiedSlotsMoto");
      // print("Parking Section Car: $parkingSectionCar");
      // print("Parking Section Moto: $parkingSectionMoto");
      // Trả về đối tượng ParkingSlotData
      return ParkingSlotData(
        occupiedSlotsCar: occupiedSlotsCar,
        occupiedSlotsMoto: occupiedSlotsMoto,
        parkingSectionCar: parkingSectionCar,
        parkingSectionMoto: parkingSectionMoto,
        spotID: spotID,
        spotName: spotName,
        bookingReservationCar: bookingReservationCar,
        bookingReservationMoto: bookingReservationMoto
      );
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }


}
Future<ParkingSlotData?> updateStateSlot(
    String spotID, String typeVehical, String slotName, int newState) async {

  try {
    String Type = 'carSlots';
    DocumentReference docRef = FirebaseFirestore.instance.collection('ParkingSlots').doc(spotID);
    if(typeVehical == 'Moto'){
      Type = 'motoSlots';
    }
    String fieldName = '$Type.$slotName';
    // Cập nhật giá trị cho A1
    await docRef.update({
      fieldName: newState, // giá trị mới cho A1
    });


    // Truy cập tài liệu của Wallet dựa trên userID và cập nhật budget
  } catch (e) {
    return null;
  }
}



