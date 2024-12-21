
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/screens/parkingBookingScreen/parking_booking_screen.dart';

import '../../Language/language.dart';
import '../../repositories/parking_slot_repository.dart';
class ParkingSlotScreen extends StatefulWidget {
  final String documentId;
  final ParkingSpotModel parkingSpotModel;
  final String userID;
  const ParkingSlotScreen({super.key, required this.documentId, required this.parkingSpotModel, required this.userID});
  @override
  State<ParkingSlotScreen> createState() => _ParkingBookingScreenState();
}
class _ParkingBookingScreenState extends State<ParkingSlotScreen> {
  LanguageSelector languageSelector = LanguageSelector();
  final String language ='vi';
  Future<ParkingSlotData?>? _futureSpotSlot;
  @override
  void initState() {
    super.initState();
    // Khởi tạo fetch dữ liệu khi widget được tạo
    _futureSpotSlot = fetchSpotSlot(widget.documentId);
  }
  String ?SpostName;
  String ?SpostID;
  String selectedFloor = 'Car';
  String lostSlotCar = ''; // Lưu vị trí đã chọn
  String lostSlotMoto = '';
  int CarOfMoto = 1;
// Danh sách các vị trí đã có xe, sẽ cập nhật từ Firestore
  List<String> occupiedSlotsCar = [];
  List<String> occupiedSlotsMoto = [];
  List<String> parkingSectionCar = [];
  List<String> parkingSectionMoto = [];
  List<String> bookingReservationCar = [];
  List<String> bookingReservationMoto = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParkingSlotData?>(
      future: _futureSpotSlot,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Hiển thị khi đang tải dữ liệu
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi khi lấy dữ liệu'));
        } else if (snapshot.hasData && snapshot.data != null) {
          ParkingSlotData data = snapshot.data!;
          SpostName = data.spotName;
          SpostID= data.spotID;
          // Cập nhật danh sách các vị trí đã chiếm dụng nếu chúng chưa có dữ liệu
          if (occupiedSlotsCar.isEmpty
              && occupiedSlotsMoto.isEmpty
              && parkingSectionMoto.isEmpty
              && parkingSectionCar.isEmpty
              && bookingReservationMoto.isEmpty
              && bookingReservationCar.isEmpty) {
            occupiedSlotsCar = data.occupiedSlotsCar;
            occupiedSlotsMoto = data.occupiedSlotsMoto;
            parkingSectionMoto = data.parkingSectionMoto;
            parkingSectionCar = data.parkingSectionCar;
            bookingReservationCar = data.bookingReservationCar;
            bookingReservationMoto = data.bookingReservationMoto;
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text('Học viện Ngân hàng',
                style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [],
            ),
            body: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Floor Selector
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFloorButton('Car'),
                        _buildFloorButton('Moto'),
                      ],
                    ),
                  ),
                  // Parking Lots Section
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 30),
                      children: [
                        if (selectedFloor == 'Car') ...[
                          _buildParkingSectionCar(
                            languageSelector.translate('Slots', language),
                            parkingSectionCar,
                            occupiedSlotsCar,
                            bookingReservationCar
                          ),
                        ] else ...[
                          _buildParkingSectionMoto(
                            languageSelector.translate('Slots', language),
                            parkingSectionMoto,
                            occupiedSlotsMoto,
                            bookingReservationMoto,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: Text('Không có dữ liệu'));
        }
      },
    );
  }
  // Floor button widget
  Widget _buildFloorButton(String floor) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFloor == floor ? Colors.blue : Colors.white30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),

        ),
        minimumSize:Size(Get.width/2.3, Get.width/8)
      ),
      onPressed: () {
        setState(() {
          selectedFloor = floor;
          lostSlotCar = '';
          lostSlotMoto = '';
          // Reset vị trí chọn khi chuyển tầng
        });
      },
      child: Text(
        floor,
        style: TextStyle(
          color: selectedFloor == floor ? Colors.white : Colors.grey[400],
          fontSize: Get.width/25,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  // Parking section widget
  Widget _buildParkingSectionCar(String section, List<String> slots, List<String> occupiedSlots, List<String> reservationSlots) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.width / 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                section,
                style: TextStyle(fontSize: Get.width / 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: Get.width / 30),
              Text(
                languageSelector.translate('Parking Slot', language),
                style: TextStyle(color: Colors.grey, fontSize: Get.width / 25),
              ),
              SizedBox(width: Get.width / 30),
              const Icon(Icons.crop, color: Colors.blue, size: 20),
            ],
          ),
          SizedBox(height: Get.width / 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            itemCount: slots.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: Get.width / 30,
              mainAxisSpacing: Get.width / 30,
            ),
            itemBuilder: (context, index) {
              String slot = slots[index];
              bool isOccupied = occupiedSlots.contains(slot);
              bool isReservated = reservationSlots.contains(slot);
              return GestureDetector(
                onTap: () {
                  if (!isOccupied && !isReservated) {
                    setState(() {
                      lostSlotCar = slot; // Cập nhật vị trí chọn
                    });
                    _showBookingDialog(slot,CarOfMoto);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: lostSlotCar == slot ? Colors.blue :
                         isOccupied ? Colors.red :
                             isReservated ? Colors.yellow :
                                 Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isOccupied
                      ? Image.asset(
                    'assets/images/detail/carImage.png',
                    width: Get.width/5,
                    height: 30,
                    fit: BoxFit.cover,
                  )
                      : Text(
                    slot,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildParkingSectionMoto(String section, List<String> slots, List<String> occupiedSlots, List<String> reservationSlots) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.width / 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                section,
                style: TextStyle(fontSize: Get.width / 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: Get.width / 30),
              Text(
                languageSelector.translate('Parking Slot', language),
                style: TextStyle(color: Colors.grey, fontSize: Get.width / 25),
              ),
              SizedBox(width: Get.width / 30),
              const Icon(Icons.crop, color: Colors.blue, size: 20),
            ],
          ),
          SizedBox(height: Get.width / 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            itemCount: slots.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: Get.width / 30,
              mainAxisSpacing: Get.width / 30,
            ),
            itemBuilder: (context, index) {
              String slot = slots[index];
              bool isOccupied = occupiedSlots.contains(slot);
              bool isReservated = reservationSlots.contains(slot);
              return GestureDetector(
                onTap: () {
                  if (!isOccupied && !isReservated) {
                    setState(() {
                      lostSlotMoto = slot; // Cập nhật vị trí chọn
                    });
                    CarOfMoto =0;
                    _showBookingDialog(slot,CarOfMoto);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: lostSlotMoto == slot ? Colors.blue :
                      isOccupied ? Colors.red :
                        isReservated ? Colors.yellow :
                          Colors.lightGreenAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isOccupied
                      ? Image.asset(
                    'assets/images/detail/motoImage.png',
                    width: 50,
                    height: 30,
                    fit: BoxFit.cover,
                  )
                      : Text(
                    slot,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Phương thức để hiển thị thông báo nổi
  void _showBookingDialog(String slot, int CarOfMoto) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(languageSelector.translate('Booking Slot', language)),

          content: Text(
            '${languageSelector.translate('Selected parking slot:', language)} $slot of $selectedFloor',
          ),

          actions: <Widget>[
            TextButton(
              child: Text(languageSelector.translate('Booking Now', language), style: TextStyle(color: Colors.blue)),
              onPressed: () {
                //print('Vị trí đã chọn :$slot !'); // In ra vị trí đã chọn
                // Navigator.of(context).pop(); // Đóng dialog
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ParkingBookingDetailScreen(parkingSpotModel: widget.parkingSpotModel, TypeSelected: selectedFloor, NameSlot: slot, userID: widget.userID,)),
                );
              },
            ),
            TextButton(
              child: Text(languageSelector.translate('Cancel', language), style: TextStyle(color: Colors.grey)),
              onPressed: () {
                setState(() {
                  lostSlotCar = '';
                  lostSlotMoto = '';// Reset vị trí chọn khi huỷ
                });
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }
}
