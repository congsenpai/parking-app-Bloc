import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/repositories/user_reponsitory.dart';

import '../../../constants.dart';

class CustomerList extends StatefulWidget {
  final String userName;
  final bool isAdmin;

  const CustomerList({
    Key? key,
    required this.userName,
    required this.isAdmin,
  }) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {

  late Future<List<UserModel>> _futureUsers;

  @override

  void initState() {
    super.initState();
    print('00000');
    print(widget.userName);
    _loadData(); // Gọi hàm load dữ liệu ban đầu
  }

  // Hàm để load dữ liệu
  void _loadData() {
    setState(() {
      if (widget.isAdmin ) {
        if(widget.userName.isEmpty) {
          _futureUsers = UserRepository().getAllUser();
        }
        else{
          print('search data: ${widget.userName}');
          _futureUsers = UserRepository().getUserByUserName(widget.userName);
        }

      }
      else{
        print('search data: ${widget.userName}');
        _futureUsers = UserRepository().getUserByUserName(widget.userName);
      }
    });
  }
  @override
  void didUpdateWidget(covariant CustomerList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kiểm tra nếu userName thay đổi thì load lại dữ liệu
    if (oldWidget.userName != widget.userName) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No user available."));
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
                  "User",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Phone")),
                      DataColumn(label: Text("State")),
                      DataColumn(label: Text("Action")),
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
DataRow recentFileDataRowAdmin(UserModel fileInfo, VoidCallback refreshData) {
  return DataRow(
    cells: [
      DataCell(Text(fileInfo.username)), // Hiển thị tên người dùng
      DataCell(Text(fileInfo.phone.isEmpty ? 'null' : fileInfo.phone)),
      DataCell(Text(fileInfo.isActive == true ? 'Active' : 'Inactive')),
      DataCell(
        IconButton(
          onPressed: () async {
            // Cập nhật trạng thái isActive
            bool newState = !fileInfo.isActive;
            await UserRepository()
                .updateStateUserByUsername(fileInfo.username, newState);
            refreshData(); // Làm mới giao diện
          },
          icon: Icon(Icons.transform),
          color: fileInfo.isActive ? Colors.green : Colors.red,
        ),
      ),
    ],
  );
}
