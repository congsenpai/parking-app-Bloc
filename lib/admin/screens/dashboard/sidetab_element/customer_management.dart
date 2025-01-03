import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../components/customer_list.dart';
import '../components/search_widget.dart';

class CustomerManagement extends StatefulWidget {
  final String userName;
  final bool isAdmin;
  final String spotID;

  const CustomerManagement({
    super.key,
    required this.userName,
    required this.isAdmin, required this.spotID,
  });

  @override
  State<CustomerManagement> createState() => _CustomerManagementState();
}

class _CustomerManagementState extends State<CustomerManagement> {
  String searchUserName = ''; // Biến để lưu giá trị tìm kiếm

  @override
  void initState() {
    super.initState();
    searchUserName = widget.userName; // Gán giá trị ban đầu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bgColor,
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(Get.width / 30),
            child: Column(
              children: [
                widget.isAdmin == true ?
                SearchField(
                  controllerText: searchUserName,
                  onSearch: (value) {
                    setState(() {
                      searchUserName = value; // Cập nhật giá trị tìm kiếm
                    });
                  },
                ): Center(
                  child: Text('Customer List'),
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomerList(
                        userName: searchUserName,
                        isAdmin: widget.isAdmin, spotID: widget.spotID,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
