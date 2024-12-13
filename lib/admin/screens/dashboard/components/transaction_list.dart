

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';

import '../../../constants.dart';


class TransactionList extends StatelessWidget {
  final bool inOrOut;
  final String SpotName;
  final bool typeTab;
  final bool isAdmin;
  const TransactionList({

    Key? key, required this.SpotName, required this.typeTab, required this.inOrOut, required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<TransactionModel>>(


        future: isAdmin == true ? TransactionRepository().get10RecentTransactions() :
          SpotName != '' ? TransactionRepository().getTransactionsByNameSpot(SpotName) :
                TransactionRepository().getAllTransactions(),

        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No parking spots available."));
          }
          final demoRecentFiles = snapshot.data!;

          return Container(
            padding: EdgeInsets.all(Get.width/40),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transaction",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: typeTab == true ?
                    DataTable(
                      columnSpacing: 20,
                      // minWidth: 600,
                      columns: [
                        DataColumn(
                          label: Text("Time"),
                        ),
                        DataColumn(
                          label: Text("Type"),
                        ),
                        DataColumn(
                          label: Text("Budget"),
                        ),
              
                      ],
                      rows: List.generate(
                        demoRecentFiles.length,
                            (index) => recentFileDataRowAdmin(demoRecentFiles[index]),
                      ),
                    ) :
                    DataTable(
                      columnSpacing: 20,
              
                      // minWidth: 600,
                      columns: [
                        DataColumn(
                          label: Text("Time"),
                        ),
                        DataColumn(
                          label: Text("Type"),
                        ),
                        DataColumn(
                          label: Text("Budget"),
                        ),
                        DataColumn(
                            label: Text("Spot \nName")
                        ),
                      ],
                      rows: List.generate(
                        demoRecentFiles.length,
                            (index) => recentFileDataRowOnSideTabAdmin(demoRecentFiles[index]),
                      ),
                    )
                    ,
                  ),
                ],
              ),
            ),
          );
        }
        );
  }
}

DataRow recentFileDataRowAdmin(TransactionModel fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Text(DateFormat('dd-MM-yyyy').format(fileInfo.date.toDate()),
          maxLines: 1,
          overflow: TextOverflow.ellipsis, // Sử dụng ellipsis để hiển thị ba dấu chấm khi chữ quá dài
        ),

      ),
      DataCell(Text(fileInfo.transactionType==true ? 'nạp' : 'thanh toán',maxLines: 5,)
      ),
      DataCell(Text(fileInfo.total.toString(), maxLines: 5,)),
    ],
  );
}

DataRow recentFileDataRowOnSideTabAdmin(TransactionModel fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Text(
            DateFormat('dd-MM \nyyyy').format(fileInfo.date.toDate()),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: Get.width/35),
          // Sử dụng ellipsis để hiển thị ba dấu chấm khi chữ quá dài
          ),

      ),
      DataCell(
        Text(
          fileInfo.transactionType==true ? 'nạp' : 'thanh toán',
          maxLines: 5,
          style: TextStyle(fontSize: Get.width/35),
        ),
      ),
      DataCell(Text(fileInfo.total.toString(),maxLines: 5,)),
      DataCell(
        Text(fileInfo.spotName,
          maxLines: 5,
          // Hiển thị tối đa 3 dòng
          style: TextStyle(fontSize: Get.width/35), // Cho phép chữ xuống dòng
        ),
      )
    ],
  );
}
