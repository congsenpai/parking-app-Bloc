// ignore_for_file: unused_import, avoid_print, non_constant_identifier_names

import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/repositories/parking_slot_repository.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';
import 'booking_event.dart';
import 'booking_state.dart';
class Data {
  final TimeOfDay? totalTime; // Thời gian tổng cộng
  final double total;         // Tổng chi phí
  Data({required this.totalTime, required this.total});
}
int getNumberOfDaysInMonth(int year, int month) {
  // Sử dụng DateTime để tính ngày đầu tiên của tháng kế tiếp
  DateTime nextMonth = (month == 12)
      ? DateTime(year + 1, 1, 1)
      : DateTime(year, month + 1, 1);

  // Trừ một ngày để quay về ngày cuối cùng của tháng
  DateTime lastDayOfCurrentMonth = nextMonth.subtract(Duration(days: 1));
  return lastDayOfCurrentMonth.day;
}
Data? calculateTotalCar({
  required DateTime? selectedDateStart,
  required DateTime? selectedDateEnd,
  required TimeOfDay? startTime,
  required TimeOfDay? endTime,
  required double pricePerHourCar,
  required double insuranceDiscount, // Giá trị giảm giá
}) {
  if (selectedDateStart != null && selectedDateEnd != null && startTime != null && endTime != null) {
    DateTime startDateTime = DateTime(
      selectedDateStart.year,
      selectedDateStart.month,
      selectedDateStart.day,
      startTime.hour,
      startTime.minute,
    );
    DateTime endDateTime = DateTime(
      selectedDateEnd.year,
      selectedDateEnd.month,
      selectedDateEnd.day,
      endTime.hour,
      endTime.minute,
    );
    //print(selectedDateStart);
    print(selectedDateEnd);
    print(startTime);
    print(endTime);
    if (selectedDateStart.isBefore(selectedDateEnd) ||
        (selectedDateStart.isAtSameMomentAs(selectedDateEnd) && startTime.hour < endTime.hour) ||
        (selectedDateStart.isAtSameMomentAs(selectedDateEnd) && startTime.hour == endTime.hour && startTime.minute < endTime.minute)){
      final int totalMinutes = endDateTime.difference(startDateTime).inMinutes;
      TimeOfDay totalTime = TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
      double totalCost = (totalMinutes / 60) * pricePerHourCar * (1 + insuranceDiscount);
      double roundedTotalCost = double.parse((totalCost).toStringAsFixed(3));
      return Data(totalTime: totalTime, total: roundedTotalCost);
    } else {
      // Ngày bắt đầu phải trước ngày kết thúc
      return Data(totalTime: const TimeOfDay(hour: 0, minute: 0), total: 0);
    }
  }
  // Nếu các tham số không hợp lệ
  return Data(totalTime: const TimeOfDay(hour: 0, minute: 0), total: 0);
}
class BookingScreenBloc extends Bloc<BookingScreenEvent, BookingScreenState> {
  BookingScreenBloc()
      : super(BookingScreenInitial()) {
    on<SelectAndCheckTimeEvent>(_selectAndCheckTimeEvent);
    on<CheckOut>(_checkOutBooking);
    on<MonthlyPackageEvent>(_MonthlyPackageEvent);
  }
  // Định nghĩa lại hàm _homeScreenLoading với đúng cú pháp và kiểu trả về
  Future<void> _selectAndCheckTimeEvent(SelectAndCheckTimeEvent event,
      Emitter<BookingScreenState> emit) async {
    // emit(HomeScreenLoading());
    try {
      DateTime? selectedDateStart = event.startingDate;
      DateTime? selectedDateEnd = event.endingDate;
      TimeOfDay? startTime =event.startingTime;
      TimeOfDay? endTime =event.endingTime;
      double pricePerHourCar =event.pricePerHourCar;
      double insuranceDiscount = event.insuranceDiscount;

      Data? data = calculateTotalCar(
          selectedDateStart: selectedDateStart,
          selectedDateEnd: selectedDateEnd,
          startTime: startTime,
          endTime: endTime,
          pricePerHourCar: pricePerHourCar,
          insuranceDiscount: insuranceDiscount);
      print(data);
      if (data?.totalTime != null) {
        emit(BookingScreenLoaded(data!.totalTime, data.total,selectedDateStart,selectedDateEnd,startTime,endTime));  // Dùng `!` để đảm bảo totalTime không phải null
      } else {
        emit(BookingScreenError("Total time is invalid"));
      }
    } catch (e) {
      emit(BookingScreenError("Failed to load parking spots"));
    }
  }


  Future<void> _MonthlyPackageEvent(MonthlyPackageEvent event,
      Emitter<BookingScreenState> emit) async {
    try {
      String time = event.time;
      List<String> parts = time.split('/');

      // Convert parts to integers
      int month = int.parse(parts[0]);
      int year = int.parse(parts[1]);

      // Lấy số ngày trong tháng
      int dayOfMonth = getNumberOfDaysInMonth(year, month);

      // Thời gian bắt đầu (start time) là thời gian hiện tại
      Timestamp startTime = Timestamp.now();

      // Tính ngày cuối cùng của tháng (end time)
      DateTime lastDayOfMonth = DateTime(year, month + 1, 0); // Ngày cuối của tháng
      Timestamp endTime = Timestamp.fromDate(lastDayOfMonth);

      // Tính tổng chi phí (price calculation) - Đây là ví dụ với công thức của bạn
      double total = dayOfMonth * 30 * event.pricePerHourCar / 2;

      // Emit trạng thái với tổng chi phí và thời gian bắt đầu và kết thúc
      emit(BookingScreenLoadedMonth(
          total,
          '${month.toString()}/${year.toString()}',
          startTime, // Gửi thời gian bắt đầu
          endTime // Gửi thời gian kết thúc
      ));
    } catch (e) {
      emit(BookingScreenError("Failed to load parking spots"));
    }
  }
// Giả lập hàm lấy số ngày trong tháng
  int getNumberOfDaysInMonth(int year, int month) {
    final lastDay = DateTime(year, month + 1, 0); // Ngày cuối của tháng
    return lastDay.day;
  }

  Future<void> _checkOutBooking(CheckOut event,
      Emitter<BookingScreenState> emit) async {


    try {
      print(event.transactionModel.userID);
      WalletRepository walletRepository  = WalletRepository();
      double balance = await walletRepository.getBalanceByUserID(event.transactionModel.userID) as double;
      print(balance);
      double Total = event.transactionModel.total.toDouble();
      print(Total);
      double RemainingBalance = balance - Total;
      print(RemainingBalance);
      if(RemainingBalance > 0){
        // Lấy dữ liệu từ sự kiện
        TransactionModel data = event.transactionModel;
        String spotID = event.spotID;

        // Khởi tạo TransactionRepository
        TransactionRepository a = TransactionRepository();

        // Chờ kết quả từ hàm addTransaction (bởi vì là async)
        await a.addTransaction(data);

        // Thông báo thành công
        emit(BookingSuccess());
        print(data.typeVehical);
        await updateStateSlot(spotID, data.typeVehical, data.slotName, 1);


        walletRepository.updateWalletBalance(event.transactionModel.userID, RemainingBalance);

        print("trừ tiên thành công");
        emit(BookingSuccess());
      }
      else{
        emit(BookingScreenError("Transaction failure because your balance isn''t enough"));
      }
    } catch (e) {
      emit(BookingScreenError("Failed to load parking spots"));
    }
  }

}


