import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../../../models/spot_owner_model.dart';
import '../../../../repositories/spot_owner_repository.dart';
import '../../../constants.dart';

class SpotOwnerList extends StatefulWidget {
  final String SpotOwnerName;
  final bool isAdmin;

  const SpotOwnerList({
    Key? key,
    required this.SpotOwnerName,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<SpotOwnerList> createState() => _SpotOwnerListState();
}

class _SpotOwnerListState extends State<SpotOwnerList> {

  late Future<List<SpotOwnerModel>> _futureSpotOwners;

  @override

  void initState() {
    super.initState();

    print(widget.SpotOwnerName);
    _loadData(); // Gọi hàm load dữ liệu ban đầu
  }

  // Hàm để load dữ liệu
  void _loadData() {
    setState(() {
      if (widget.isAdmin ) {
        if(widget.SpotOwnerName.isEmpty) {
          _futureSpotOwners = SpotOwnerRepository().getAllSpotOwners();
        }
        else{
          print('search data: ${widget.SpotOwnerName}');
          _futureSpotOwners = SpotOwnerRepository().getSpotOwnersByName(widget.SpotOwnerName);
        }

      }
      else{
        print('search data: ${widget.SpotOwnerName}');
        _futureSpotOwners = SpotOwnerRepository().getSpotOwnersByName(widget.SpotOwnerName);
      }
    });
  }
  @override
  void didUpdateWidget(covariant SpotOwnerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu SpotOwnerName thay đổi thì load lại dữ liệu
    if (oldWidget.SpotOwnerName != widget.SpotOwnerName) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SpotOwnerModel>>(
      future: _futureSpotOwners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No SpotOwner available."));
        }
        final demoRecentFiles = snapshot.data!;

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
                  "SpotOwner",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Time",style: TextStyle(fontSize: Get.width/35),)),
                      DataColumn(label: Text("Name",style: TextStyle(fontSize: Get.width/35),)),
                      DataColumn(label: Text("Phone",style: TextStyle(fontSize: Get.width/35),)),
                      DataColumn(label: Text("State",style: TextStyle(fontSize: Get.width/35),)),

                      DataColumn(label: Text("Action",style: TextStyle(fontSize: Get.width/35),)),
                    ],
                    rows: List.generate(
                      demoRecentFiles.length,
                          (index) => recentFileDataRowAdmin(
                        demoRecentFiles[index],
                        _loadData, // Truyền hàm load lại dữ liệu
                      ),
                    ),
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
DataRow recentFileDataRowAdmin(SpotOwnerModel fileInfo, VoidCallback refreshData) {
  return DataRow(
    cells: [
      DataCell(Text(DateFormat('dd-MM\nyyyy').format(fileInfo.createdTime.toDate()),style: TextStyle(fontSize: Get.width/35),)),
      DataCell(Text(fileInfo.spotOwnerName,style: TextStyle(fontSize: Get.width/40),)), // Hiển thị tên người dùng
      DataCell(Text(fileInfo.phoneNumber.toString(),style: TextStyle(fontSize: Get.width/35),)),
      DataCell(Text(fileInfo.isActive == true ? 'Act' : 'UnAct',style: TextStyle(fontSize: Get.width/35),)),
      DataCell(
        IconButton(
          onPressed: () async {
            // Cập nhật trạng thái isActive
            bool newState = !fileInfo.isActive;
            print('thông tin ${fileInfo.phoneNumber}');
            await SpotOwnerRepository.updateSpotOwnerStatus(fileInfo.spotOwnerID, newState);
            refreshData(); // Làm mới giao diện
          },
          icon: Icon(Icons.transform),
          color: fileInfo.isActive ? Colors.green : Colors.red,
        ),
      ),
    ],
  );
}
