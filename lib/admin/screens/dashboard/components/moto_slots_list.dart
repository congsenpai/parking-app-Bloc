import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../repositories/parking_slot_repository.dart';
import '../../../constants.dart';

class SpotMotosList extends StatefulWidget {
  final String SpotMotosName;
  final bool isAdmin;
  final String spotId;

  const SpotMotosList({
    Key? key,
    required this.SpotMotosName,
    required this.isAdmin, required this.spotId,
  }) : super(key: key);

  @override
  State<SpotMotosList> createState() => _SpotMotosListState();
}

class _SpotMotosListState extends State<SpotMotosList> {

  late Future<ParkingSlotData?> _futureSpotMotos;

  @override

  void initState() {
    super.initState();
    print('00000');
    print(widget.SpotMotosName);
    _loadData(); // Gọi hàm load dữ liệu ban đầu
  }

  // Hàm để load dữ liệu
  void _loadData() {
    setState(() {
      if (!widget.isAdmin) {
        if(widget.SpotMotosName.isEmpty) {
          _futureSpotMotos = (fetchSpotSlot(widget.spotId));
        }
        else{
          print('search data: ${widget.SpotMotosName}');
          _futureSpotMotos = (fetchSpotSlot(widget.spotId));
        }

      }
      else{
        print('Do not permission' );
      }
    });
  }
  @override
  void didUpdateWidget(covariant SpotMotosList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu SpotMotosName thay đổi thì load lại dữ liệu
    if (oldWidget.SpotMotosName != widget.SpotMotosName) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParkingSlotData?>(
      future: _futureSpotMotos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData ) {
          return Center(child: Text("No SpotMotos available."));
        }
        final demoRecentFiles = snapshot.data!;
        final List<String> occupiedSlotsMoto = demoRecentFiles.occupiedSlotsMoto;
        final List<String> parkingSectionMoto = demoRecentFiles.parkingSectionMoto;
        final List<String> bookingReservationMoto = demoRecentFiles.bookingReservationMoto;

        final Map<String,String> data = {};
        for (final slot in occupiedSlotsMoto){
          data[slot] = '2';
        }
        for (final slot in parkingSectionMoto){
          data[slot] = '0';
        }
        for (final slot in bookingReservationMoto){
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
                  "SpotMotos",
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
                          DataCell(Text(occupiedSlotsMoto.length.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Booking Slot')),
                          DataCell(Text(bookingReservationMoto.length.toString())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Total on Spot')),
                          DataCell(Text(parkingSectionMoto.length.toString())),
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
