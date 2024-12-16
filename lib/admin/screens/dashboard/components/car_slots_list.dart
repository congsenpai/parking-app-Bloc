import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../repositories/parking_slot_repository.dart';
import '../../../constants.dart';

class SpotCarsList extends StatefulWidget {
  final String SpotCarsName;
  final bool isAdmin;
  final String spotId;

  const SpotCarsList({
    Key? key,
    required this.SpotCarsName,
    required this.isAdmin, required this.spotId,
  }) : super(key: key);

  @override
  State<SpotCarsList> createState() => _SpotCarsListState();
}

class _SpotCarsListState extends State<SpotCarsList> {

  late Future<ParkingSlotData?> _futureSpotCars;

  @override

  void initState() {
    super.initState();
    print('00000');
    print(widget.SpotCarsName);
    _loadData(); // Gọi hàm load dữ liệu ban đầu
  }

  // Hàm để load dữ liệu
  void _loadData() {
    setState(() {
      if (!widget.isAdmin) {
        if(widget.SpotCarsName.isEmpty) {
          _futureSpotCars = (fetchSpotSlot(widget.spotId));
        }
        else{
          print('search data: ${widget.SpotCarsName}');
          _futureSpotCars = (fetchSpotSlot(widget.spotId));
        }

      }
      else{
        print('Do not permission' );
      }
    });
  }
  @override
  void didUpdateWidget(covariant SpotCarsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu SpotCarsName thay đổi thì load lại dữ liệu
    if (oldWidget.SpotCarsName != widget.SpotCarsName) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParkingSlotData?>(
      future: _futureSpotCars,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData ) {
          return Center(child: Text("No SpotCars available."));
        }
        final demoRecentFiles = snapshot.data!;
        final List<String> occupiedSlotsCar = demoRecentFiles.occupiedSlotsCar;
        final List<String> parkingSectionCar = demoRecentFiles.parkingSectionCar;
        final List<String> bookingReservationCar = demoRecentFiles.bookingReservationCar;

        final Map<String,String> data = {};
          for (final slot in occupiedSlotsCar){
            data[slot] = '2';
          }
          for (final slot in parkingSectionCar){
            data[slot] = '0';
          }
          for (final slot in bookingReservationCar){
            data[slot] = '1';
          }



        return Container(
          padding: EdgeInsets.all(Get.width / 40),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "SpotCars",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Type")),
                      DataColumn(label: Text("Acounts")),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('Occupied Slot')),
                        DataCell(Text(occupiedSlotsCar.length.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Booking Slot')),
                        DataCell(Text(bookingReservationCar.length.toString())),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Total on Spot')),
                        DataCell(Text(parkingSectionCar.length.toString())),
                      ])
                    ]
                  ),
                ),
                SizedBox(height: Get.width/10,),
                Text(
                  "Detail",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("State")),
                    ],
                    rows: data.entries.map((entry) {
                      return recentFileDataRowAdmin(entry.key, entry.value, _loadData);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Hàm tạo DataRow cho mỗi người dùng
DataRow recentFileDataRowAdmin(String name, String state, VoidCallback refreshData) {
  return DataRow(
    cells: [
      DataCell(Text(name)), // Hiển thị tên từ key
      DataCell(Text(state == '2'?'Occupied': state == '1' ?'Booking':'Empty')), // Hiển thị trạng thái từ value
    ],
  );
}
