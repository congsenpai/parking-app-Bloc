// ignore_for_file: unused_import

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_event.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_state.dart';

import 'package:project_smart_parking_app/models/transaction_model.dart';

import 'package:project_smart_parking_app/repositories/transaction_repository.dart';



class OrderDetailScreenBloc extends Bloc<OrderDetailScreenEvent, OrderDetailScreenState> {

  final TransactionRepository transactionRepository;

  OrderDetailScreenBloc(this.transactionRepository)
      : super(OrderDetailScreenInitial()) {
    on<OrderDetailEvent>(_GetDataOrderDetail);
  }

  // Định nghĩa lại hàm _OrderDetailLoading với đúng cú pháp và kiểu trả về
  Future<void> _GetDataOrderDetail(OrderDetailEvent event,
      Emitter<OrderDetailScreenState> emit) async {
    // emit(OrderDetailLoading());

    try {
      TransactionRepository transactionRepository = TransactionRepository();
      TransactionModel? transactionModel = await transactionRepository.getTransactionsByID(event.transactionID);
      print(transactionModel);
      emit(OrderDetailScreenLoaded(transactionModel!));
      

    } catch (e) {
      emit(OrderDetailScreenError("Failed to load parking spots"));
    }
  }
}
