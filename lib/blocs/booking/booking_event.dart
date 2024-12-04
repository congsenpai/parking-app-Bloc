import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';


abstract class BookingScreenEvent {}

class LoadParkingSpotsEvent extends BookingScreenEvent {

}

class SelectAndCheckTimeEvent extends BookingScreenEvent {
  late List<String> VehicalLisence;
  late final DateTime startingDate;
  late final DateTime endingDate;
  late final TimeOfDay startingTime;
  late final TimeOfDay endingTime;
  late final double pricePerHourCar;
  late final double insuranceDiscount;




  SelectAndCheckTimeEvent(this.startingDate, this.endingDate, this.startingTime, this.endingTime, this.pricePerHourCar, this.insuranceDiscount);
}
class CheckOut extends BookingScreenEvent{
  late String spotID;

  late TransactionModel transactionModel;
  CheckOut(this.transactionModel,this.spotID);
}

