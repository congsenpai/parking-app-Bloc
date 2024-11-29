import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
class Data {
  final TimeOfDay? totalTime; // Thời gian tổng cộng
  final double total;         // Tổng chi phí
  Data({required this.totalTime, required this.total});
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
}


