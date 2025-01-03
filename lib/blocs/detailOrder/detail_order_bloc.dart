// ignore_for_file: unused_import, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_event.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_state.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';

import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';

import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/user_reponsitory.dart';

import '../../repositories/parking_slot_repository.dart';



class OrderDetailScreenBloc extends Bloc<OrderDetailScreenEvent, OrderDetailScreenState> {
  Timestamp getRemainingTimestamp(Timestamp endTime) {
    // Lấy thời gian hiện tại
    DateTime nowDateTime = Timestamp.now().toDate();

    // Chuyển đổi `endTime` sang `DateTime`
    DateTime endDateTime = endTime.toDate();

    // Tính sự khác biệt giữa `endTime` và `now`
    Duration remainingDuration = endDateTime.difference(nowDateTime);

    // Trả về Timestamp từ Duration còn lại
    return Timestamp.fromDate(nowDateTime.add(remainingDuration));
  }

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
      Timestamp RemainingTime= Timestamp(0, 0);
      bool expired = false;
      TransactionRepository transactionRepository = TransactionRepository();
      TransactionModel? transactionModel = await transactionRepository.getTransactionsByID(event.transactionID);

      UserRepository userRepository = UserRepository();
      UserModel? userModel = await userRepository.getUserByID(transactionModel!.userID);


      if(transactionModel.endTime.toDate().isBefore(Timestamp.now().toDate()) && transactionModel.transactionType == false){
        ParkingSpotRepository parkingSpotRepository = ParkingSpotRepository();
        List<ParkingSpotModel> spots = await parkingSpotRepository.getAllParkingSpotsBySearchSpotName(transactionModel.spotName);
        ParkingSpotModel spot = spots[0];
        expired = true;
        await updateStateSlot(spot.spotId, transactionModel.typeVehical, transactionModel.slotName, 0);
        RemainingTime = getRemainingTimestamp(transactionModel.endTime);
      }


      emit(OrderDetailScreenLoaded(transactionModel,userModel!,expired,RemainingTime));
      

    } catch (e) {
      emit(OrderDetailScreenError("Failed to load parking spots"));
    }
  }
}
