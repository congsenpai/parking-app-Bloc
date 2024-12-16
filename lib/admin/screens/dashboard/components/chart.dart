import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  final bool isAdmin;
  final String SpotID;
  const Chart({
    Key? key, required this.isAdmin, required this.SpotID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Income?>(
        future: isAdmin ? TransactionRepository().getIncomefromTransactionsAll()
        : TransactionRepository().getIncomefromTransactionsBySpotName(SpotID),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData ) {
            return Center(child: Text("No parking spots available."));
          }
          Income income = snapshot.data!;
          List<PieChartSectionData> paiChartSelectionData = [
            PieChartSectionData(
              color: primaryColor,
              value: income.IncomeByBookingSlot,
              showTitle: false,
              radius: 25,
            ),
            PieChartSectionData(
              color: Color(0xFF26E5FF),
              value: income.IncomeByRecharge,
              showTitle: false,
              radius: 22,
            ),
            PieChartSectionData(
              color: Color(0xFFFFCF26),
              value: income.IncomeByCombo,
              showTitle: false,
              radius: 19,
            ),
            // PieChartSectionData(
            //   color: Color(0xFFEE2727),
            //   value: income.IncomeByCommission,
            //   showTitle: false,
            //   radius: 16,
            // ),
            PieChartSectionData(
              color: primaryColor.withOpacity(0.1),
              value: income.IncomeByOther,
              showTitle: false,
              radius: 13,
            ),
          ];

          return SizedBox(
            height: 200,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    startDegreeOffset: -90,
                    sections: paiChartSelectionData,
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: defaultPadding),
                      Text(
                        '${income.Incomes}',
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          height: 0.5,
                          fontSize: 15
                        ),
                      ),
                      Text('VNĐ'),

                    ],
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}



