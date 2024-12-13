import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants.dart';
import '../../../responsive.dart';
import '../components/header.dart';
import '../components/parking_spot_list.dart';
import '../components/search_widget.dart';
import '../components/transaction_list.dart';
import '../components/income_details.dart';

class TransactionManagement extends StatefulWidget {
  final String SpotName;
  const TransactionManagement({super.key, required this.SpotName});


  @override
  State<TransactionManagement> createState() => _TransactionManagementState();
}

class _TransactionManagementState extends State<TransactionManagement> {
  @override
  String spotName = ""; // Biến để lưu giá trị tìm kiếm
  @override
  void initState() {
    super.initState();
    spotName = widget.SpotName; // Gán giá trị ban đầu
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bgColor,
          child: SingleChildScrollView(
            primary: false,
            padding: EdgeInsets.all(Get.width/30),
            child: Column(
              children: [
                SearchField(
                  controllerText: spotName,
                  onSearch: (value) {
                    setState(() {
                      spotName = value; // Cập nhật giá trị spotName
                    });
                    print("Search value: $spotName");
                  },
                ),
                SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          TransactionList(SpotName: spotName,typeTab: false, inOrOut: false, isAdmin: true,),

                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
