
import 'package:project_smart_parking_app/models/transaction_model.dart';


abstract class OrderScreenState {}

class OrderScreenInitial extends OrderScreenState {}

class OrderScreenLoading extends OrderScreenState {}

class OrderScreenLoaded extends OrderScreenState {
  final List<TransactionModel>  depositdata;
  final List<TransactionModel>  withdrawdata;
  OrderScreenLoaded(this.depositdata, this.withdrawdata);
}

class OrderScreenError extends OrderScreenState {
  final String message;

  OrderScreenError(this.message);
}