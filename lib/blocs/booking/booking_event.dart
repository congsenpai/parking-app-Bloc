import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/directions.dart';

abstract class HomeScreenEvent {}

class LoadParkingSpotsEvent extends HomeScreenEvent {

}

class SelectAndCheckTimeEvent extends HomeScreenEvent {

  final DateTime startingDate;
  final DateTime endingDate;
  final TimeOfDay startingTime;
  final TimeOfDay endingTime;



  SelectAndCheckTimeEvent(this.startingDate, this.endingDate, this.startingTime, this.endingTime);
}