import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../repositories/transaction_repository.dart';
import '../../../constants.dart';
import 'chart.dart';
import 'data_of_income.dart';

class IncomeDetail extends StatelessWidget {
  final bool isAdmin;
  final String SpotID;
  const IncomeDetail({
    Key? key, required this.isAdmin, required this.SpotID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Income?>(
        future: isAdmin ? TransactionRepository().getIncomefromTransactionsAll():
        TransactionRepository().getIncomefromTransactionsBySpotName(SpotID),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData ) {
            return Center(child: Text("No parking spots available."));
          }
          Income income = snapshot.data!;


          return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(Get.width/30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Income",
                  style: TextStyle(
                    fontSize: Get.width/25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: defaultPadding),
                Chart(isAdmin: isAdmin, SpotID: SpotID,),
                isAdmin == false ? StorageInfoCard(
                  svgSrc: "assets/icons/Documents.svg",
                  title: "Thu nhập từ việc đặt chỗ",
                  income: income.IncomeByBookingSlot.toString(),

                ):
                StorageInfoCard(
                  svgSrc: "assets/icons/media.svg",
                  title: "Thu nhập từ ăn hoa hồng",
                  income: income.IncomeByCommission.toString(),

                ),
                StorageInfoCard(
                  svgSrc: "assets/icons/media.svg",
                  title: "Thu nhập từ các gói đăng ký",
                  income: income.IncomeByCombo.toString(),

                ),
                StorageInfoCard(
                  svgSrc: "assets/icons/media.svg",
                  title: "Thu nhập khác",
                  income: income.IncomeByOther.toString(),

                ),
                StorageInfoCard(
                  svgSrc: "assets/icons/unknown.svg",
                  title: "Tiền nạp của khách",
                  income: income.IncomeByRecharge.toString(),

                ),

              ],
            ),
          );
        }
    );
  }
}
