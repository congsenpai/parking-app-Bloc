import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/components/car_slots_list.dart';
import 'package:project_smart_parking_app/admin/screens/dashboard/components/moto_slots_list.dart';

import '../../../constants.dart';

import '../components/search_widget.dart';

class SpotManagement extends StatefulWidget {
  final String spotName;
  final bool isAdmin;

  const SpotManagement({
    super.key,
    required this.spotName,
    required this.isAdmin,
  });

  @override
  State<SpotManagement> createState() => _SpotManagementState();
}

class _SpotManagementState extends State<SpotManagement> {
  String searchspotName = ''; // Biến để lưu giá trị tìm kiếm

  @override
  void initState() {
    super.initState();
    searchspotName = widget.spotName; // Gán giá trị ban đầu
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
                  controllerText: searchspotName,
                  onSearch: (value) {
                    setState(() {
                      searchspotName = value; // Cập nhật giá trị tìm kiếm
                    });
                    print("Search value: $searchspotName");
                  },
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SpotCarsList(
                        isAdmin: false, SpotCarsName: '', spotId: 'spotID1',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SpotMotosList(
                        isAdmin: false, spotId: 'spotID1', SpotMotosName: '',
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
