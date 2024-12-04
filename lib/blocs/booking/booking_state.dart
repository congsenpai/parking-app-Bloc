

import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/blocs/order/order_bloc.dart';
import 'package:project_smart_parking_app/screens/OrderScreen/order_screen.dart';


abstract class BookingScreenState {}

class BookingScreenInitial extends BookingScreenState {

}

class BookingScreenLoading extends BookingScreenState {}

class BookingScreenLoaded extends BookingScreenState {
  late final TimeOfDay? TotalTime;
  late final double? Total;
  late final DateTime? selectedDateStart;
  late final DateTime? selectedDateEnd;
  late final TimeOfDay? startTime;
  late final TimeOfDay? endTime;


  BookingScreenLoaded(this.TotalTime, this.Total, this.selectedDateStart, this.selectedDateEnd, this.startTime, this.endTime);
}

class BookingSuccess extends BookingScreenState{
}

class BookingScreenError extends BookingScreenState {
  final String message;

  BookingScreenError(this.message);
}