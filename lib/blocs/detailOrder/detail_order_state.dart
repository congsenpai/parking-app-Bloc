
// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/models/user_model.dart';


abstract class OrderDetailScreenState {}

class OrderDetailScreenInitial extends OrderDetailScreenState {}

class OrderDetailScreenLoading extends OrderDetailScreenState {}

class OrderDetailScreenLoaded extends OrderDetailScreenState {
  final TransactionModel transactionModel;
  final UserModel userModel;
  final bool expired;
  final Timestamp remainingTime;
  OrderDetailScreenLoaded(this.transactionModel,this.userModel, this.expired, this.remainingTime);
}

class OrderDetailScreenError extends OrderDetailScreenState {
  final String message;

  OrderDetailScreenError(this.message);
}