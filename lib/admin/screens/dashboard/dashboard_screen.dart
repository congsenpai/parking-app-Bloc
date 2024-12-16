
import 'package:flutter/material.dart';

import '../../../models/spot_owner_model.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'components/header.dart';

import 'components/parking_spot_list.dart';
import 'components/transaction_list.dart';
import 'components/income_details.dart';

class DashboardScreen extends StatelessWidget {
  final SpotOwnerModel spotOwnerModel;
  const DashboardScreen({super.key, required this.spotOwnerModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(spotOwnerModel: spotOwnerModel,),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      ParkingSpotList(isAdmin: spotOwnerModel.isAdmin, spotID: spotOwnerModel.spotID,),
                      SizedBox(height: defaultPadding),
                      TransactionList(SpotName: '',typeTab: true, inOrOut: true, isAdmin: spotOwnerModel.isAdmin,),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) IncomeDetail(isAdmin: spotOwnerModel.isAdmin, SpotID: spotOwnerModel.spotID,),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: IncomeDetail(isAdmin: spotOwnerModel.isAdmin, SpotID: spotOwnerModel.spotID,),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
