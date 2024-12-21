
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';


abstract class OrderDetailScreenState {}

class OrderDetailScreenInitial extends OrderDetailScreenState {}

class OrderDetailScreenLoading extends OrderDetailScreenState {}

class OrderDetailScreenLoaded extends OrderDetailScreenState {
  final TransactionModel transactionModel;
  OrderDetailScreenLoaded(this.transactionModel);
}

class OrderDetailScreenError extends OrderDetailScreenState {
  final String message;

  OrderDetailScreenError(this.message);
}