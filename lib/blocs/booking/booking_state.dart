

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


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

class BookingScreenLoadedMonth extends BookingScreenState{
  late final double Total;
  late final String Month;
  late final Timestamp startTime;
  late final Timestamp endTime;
  BookingScreenLoadedMonth(this.Total,this.Month,this.startTime,this.endTime);
}

class BookingSuccess extends BookingScreenState{
}

class BookingScreenError extends BookingScreenState {
  final String message;

  BookingScreenError(this.message);
}
