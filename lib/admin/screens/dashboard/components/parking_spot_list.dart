import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';
import '../../../constants.dart';

import '../../../responsive.dart';
import 'data_of_parking_spot.dart';

class ParkingSpotList extends StatelessWidget {
  const ParkingSpotList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
            crossAxisCount: 1,

          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 1,
    this.childAspectRatio = 1,
  });
  ParkingSpotRepository parkingSpotRepository = ParkingSpotRepository();

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ParkingSpotModel>>(
      future: parkingSpotRepository.getAllParkingSpots(),
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
