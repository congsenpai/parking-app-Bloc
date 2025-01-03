// ignore_for_file: unused_import, non_constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/Order/Order_event.dart';

import 'package:project_smart_parking_app/blocs/order/order_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';

import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
class OrderScreenBloc extends Bloc<OrderScreenEvent, OrderScreenState> {

  final TransactionRepository transactionRepository;

  OrderScreenBloc(this.transactionRepository)
      : super(OrderScreenInitial()) {
    on<SearchMyOrder>(_GetDataOrder);
  }

  // Định nghĩa lại hàm _OrderLoading với đúng cú pháp và kiểu trả về
  Future<void> _GetDataOrder(SearchMyOrder event,
      Emitter<OrderScreenState> emit) async {
    // emit(OrderLoading());

    try {
      final List<TransactionModel> TransactionData;
      TransactionData = await transactionRepository.getAllRecentlyTransactionsByUser(event.userID);
      if(event.searchText!='' ){
        List<TransactionModel>Transactions =
        TransactionData.where((tran)
        => tran.spotName.toLowerCase().contains(event.searchText)).toList();
        emit(OrderScreenLoaded(Transactions));}
      else{
        emit(OrderScreenLoaded(TransactionData));}
    } catch (e) {
      emit(OrderScreenError("Failed to load parking spots"));
    }
  }
}
