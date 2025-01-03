// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';
import '../../../constants.dart';

import '../../../responsive.dart';
import 'data_of_parking_spot.dart';

class ParkingSpotList extends StatelessWidget {
  final bool isAdmin;
  final String spotID;
  const ParkingSpotList({
    super.key, required this.isAdmin, required this.spotID,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                "Parking Spots",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: 1, isAdmin: isAdmin, spotID: spotID,

          ),
          tablet: FileInfoCardGridView(isAdmin: isAdmin, spotID: spotID,),
          desktop: FileInfoCardGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
            isAdmin: isAdmin, spotID: spotID,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  final bool isAdmin;
  final String spotID; 
  FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 1,
    this.childAspectRatio = 1, required this.isAdmin, required this.spotID,
  });
  ParkingSpotRepository parkingSpotRepository = ParkingSpotRepository();

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ParkingSpotModel>>(
      future: isAdmin ?parkingSpotRepository.getAllParkingSpots():parkingSpotRepository.getAllParkingSpotsBySearchSpotId(spotID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No parking spots available."));
        }
        final demoFile = snapshot.data!;
        print(demoFile);
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: demoFile.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) => DataOfParkingSpot(info: demoFile[index]),
        );
      },
    );
  }

}
