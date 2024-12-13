
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/repositories/parking_slot_repository.dart';

import '../../../constants.dart';


class DataOfParkingSpot extends StatelessWidget {
  const DataOfParkingSpot({
    Key? key,
    required this.info,
  }) : super(key: key);

  final ParkingSpotModel info;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParkingSlotData?>(
        future: fetchSpotSlot(info.spotId),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          else if(!snapshot.hasData ){
            return Center(child: Text("No parking spots available."));
          }
          ParkingSlotData parkingSlotData = snapshot.data!;
          int occupiedSlotsCar = parkingSlotData.occupiedSlotsCar.length;
          int parkingSectionCar = parkingSlotData.parkingSectionCar.length;
          int bookingReservationCar = parkingSlotData.bookingReservationCar.length;
          int totalSlot = occupiedSlotsCar + parkingSectionCar + bookingReservationCar;
          double precentoOfOccupiedSlotsCar = (occupiedSlotsCar/totalSlot);
          double precentoOfBookingReservationCar = (bookingReservationCar/totalSlot);
          double precentoOfParkingSectionCar = (parkingSectionCar/totalSlot);

          int occupiedSlotsMoto = parkingSlotData.occupiedSlotsMoto.length;
          int parkingSectionMoto = parkingSlotData.parkingSectionMoto.length;
          int bookingReservationMoto = parkingSlotData.bookingReservationMoto.length;
          int totalSlotMoto = occupiedSlotsMoto + parkingSectionMoto + bookingReservationMoto;
          double precentoOfOccupiedSlotsMoto = (occupiedSlotsMoto/totalSlotMoto);
          double precentoOfBookingReservationMoto = (bookingReservationMoto/totalSlotMoto);
          double precentoOfParkingSectionMoto = (parkingSectionMoto/totalSlotMoto);

          return Container(
            height: Get.width,
            width: Get.width/1.2,
            padding: EdgeInsets.all(Get.width/18),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: Get.width / 3, // Chiều cao là 1/3 chiều rộng màn hình
                  width: Get.width / 1.2, // Chiều rộng là 2/3 chiều rộng màn hình
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://drive.google.com/uc?export=view&id=${info.listImage[0]}'),
                      fit: BoxFit.cover, // Đảm bảo hình ảnh phủ đầy container
                    ),
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10)), // Bo góc
                  ),
                ),
                SizedBox(
                  height: Get.width/50,
                ),
                Text(
                  info.spotName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: Get.width/25
                  ),
                ),
                SizedBox(
                  height: Get.width/50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$occupiedSlotsCar Slots / ${info.OccupiedMaxCar} Slots Cars",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white70),
                    ),
                    Text(
                      '${info.costPerHourCar.toString()} VNĐ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Text('Car Slots'),
                ProgressLine(
                  occupiedSlotsPercentage: precentoOfOccupiedSlotsCar,
                  bookingReservationPercentage: precentoOfBookingReservationCar,
                  parkingSectionPercentage: precentoOfParkingSectionCar,

                ),

                SizedBox(
                  height: Get.width/50,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$occupiedSlotsMoto Slots / ${info.OccupiedMaxMotor} Slots Motos",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white70),
                    ),
                    Text(
                      '${info.costPerHourMoto.toString()} VNĐ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
                Text('Moto Slots'),
                ProgressLine(
                  occupiedSlotsPercentage: precentoOfOccupiedSlotsMoto,
                  bookingReservationPercentage: precentoOfBookingReservationMoto,
                  parkingSectionPercentage: precentoOfParkingSectionMoto,

                ),

              ],
            ),
          );


    }
    );
  }
}

class ProgressLine extends StatelessWidget {
   ProgressLine({
    Key? key, required this.occupiedSlotsPercentage,
     required this.bookingReservationPercentage,
     required this.parkingSectionPercentage,


  }) : super(key: key);

  final double? occupiedSlotsPercentage;
  final double? bookingReservationPercentage;
  final double? parkingSectionPercentage;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
          // chỗ đã bị chiếm và xe đã đến
              Container(
                width: constraints.maxWidth * (occupiedSlotsPercentage!),
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
          // chỗ đã bị chiếm và xe chưa đến
              Container(
                width: constraints.maxWidth * (bookingReservationPercentage!),
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Container(
                width: constraints.maxWidth * (parkingSectionPercentage!),
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
