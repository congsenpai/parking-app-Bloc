import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

import '../components/search_widget.dart';
import '../components/spot_owner_list.dart';

class SpotOwnerManagement extends StatefulWidget {
  final String SpotOwnerName;
  final bool isAdmin;

  const SpotOwnerManagement({
    super.key,
    required this.SpotOwnerName,
    required this.isAdmin,
  });

  @override
  State<SpotOwnerManagement> createState() => _SpotOwnerManagementState();
}

class _SpotOwnerManagementState extends State<SpotOwnerManagement> {
  String searchSpotOwnerName = ''; // Biến để lưu giá trị tìm kiếm

  @override
  void initState() {
    super.initState();
    searchSpotOwnerName = widget.SpotOwnerName; // Gán giá trị ban đầu
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
                SearchField(
                  controllerText: searchSpotOwnerName,
                  onSearch: (value) {
                    setState(() {
                      searchSpotOwnerName = value; // Cập nhật giá trị tìm kiếm
                    });
                    print("Search value: $searchSpotOwnerName");
                  },
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SpotOwnerList(
                        SpotOwnerName: searchSpotOwnerName,
                        isAdmin: widget.isAdmin,
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
