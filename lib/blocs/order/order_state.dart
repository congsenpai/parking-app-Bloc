
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';


abstract class OrderScreenState {}

class OrderScreenInitial extends OrderScreenState {}

class OrderScreenLoading extends OrderScreenState {}

class OrderScreenLoaded extends OrderScreenState {
  final List<TransactionModel>  transactions;

  OrderScreenLoaded(this.transactions);
}

class OrderScreenError extends OrderScreenState {
  final String message;

  OrderScreenError(this.message);
}