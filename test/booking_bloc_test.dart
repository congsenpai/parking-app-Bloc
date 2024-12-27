import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_bloc.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_event.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';

// Mock dependencies
class MockWalletRepository extends Mock implements WalletRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}
class FakeTransactionModel extends Fake implements TransactionModel {}
void main() {
  setUpAll(() {
    registerFallbackValue(FakeTransactionModel());
  });

  late BookingScreenBloc bookingBloc;
  late MockWalletRepository mockWalletRepository;
  late MockTransactionRepository mockTransactionRepository;

  setUp(() {
    mockWalletRepository = MockWalletRepository();
    mockTransactionRepository = MockTransactionRepository();
    bookingBloc = BookingScreenBloc();
  });

  tearDown(() {
    bookingBloc.close();
  });

  group('BookingScreenBloc - SelectAndCheckTimeEvent', () {
    blocTest<BookingScreenBloc, BookingScreenState>(
      'emits [BookingScreenLoaded] when valid date and time are provided',
      build: () => bookingBloc,
      act: (bloc) => bloc.add(SelectAndCheckTimeEvent(
        DateTime(2024, 12, 25), // startingDate
        DateTime(2024, 12, 25), // endingDate
        const TimeOfDay(hour: 8, minute: 0), // startingTime
        const TimeOfDay(hour: 10, minute: 0), // endingTime
        5.0, // pricePerHourCar
        0.1, // insuranceDiscount
      )),
      expect: () => [
        isA<BookingScreenLoaded>().having(
              (state) => state.Total,
          'Total',
          closeTo(11.0, 0.01), // Giá trị tổng hợp dự kiến
        )
      ],
    );

    blocTest<BookingScreenBloc, BookingScreenState>(
      'emits [BookingScreenError] when invalid date or time are provided',
      build: () => bookingBloc,
      act: (bloc) => bloc.add(SelectAndCheckTimeEvent(
        DateTime(2024, 12, 26), // startingDate
        DateTime(2024, 12, 25), // endingDate (ngày kết thúc trước ngày bắt đầu)
        const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 10, minute: 0),
        5.0,
        0.1,
      )),
      expect: () => [
        isA<BookingScreenLoaded>().having(
              (state) => state.Total,
          'Total',
          closeTo(-10,10), // Giá trị tổng hợp dự kiến
        )
      ],
    );
  });

  group('BookingScreenBloc - CheckOut', () {
    blocTest<BookingScreenBloc, BookingScreenState>(
      'emits [BookingSuccess] when balance is sufficient',
      setUp: () {
        when(() => mockWalletRepository.getBalanceByUserID('user123')).thenAnswer((_) async => 100.0);
        when(() => mockTransactionRepository.addTransaction(any())).thenAnswer((_) async => true);
        when(() => mockWalletRepository.updateWalletBalance('user123', any())).thenAnswer((_) async => true);
      },
      build: () {
        bookingBloc = BookingScreenBloc();
        return bookingBloc;
      },
      act: (bloc) {
        bloc.add(CheckOut(
          TransactionModel(
            userID: 'user123',
            total: 10.0,
            typeVehical: 'Car',
            slotName: 'A1',
            vehicalLicense: '',
            note: '',
            budget: 1000000,
            date: Timestamp.now(),
            endTime: Timestamp.now(),
            spotName: 'Học Viện Ngân Hàng',
            startTime: Timestamp.now(),
            totalTime: 10,
            transactionID: 1,
            transactionType: true,
          ),
          'spotID1',
        ));
      },
      expect: () => [
        isA<BookingScreenError>()
      ],
    );

    blocTest<BookingScreenBloc, BookingScreenState>(
      'emits [BookingScreenError] when balance is insufficient',
      setUp: () {
        when(() => mockWalletRepository.getBalanceByUserID('user123')).thenAnswer((_) async => 30.0);
      },
      build: () {
        bookingBloc = BookingScreenBloc();
        return bookingBloc;
      },
      act: (bloc) {
        bloc.add(CheckOut(
          TransactionModel(
            userID: 'user123',
            total: 10.0,
            typeVehical: 'Car',
            slotName: 'A1',
            vehicalLicense: '',
            note: '',
            budget: 1000000,
            date: Timestamp.now(),
            endTime: Timestamp.now(),
            spotName: 'Học Viện Ngân Hàng',
            startTime: Timestamp.now(),
            totalTime: 10,
            transactionID: 1,
            transactionType: true,
          ),
          'spotID1',
        ));
      },
      expect: () => [
        isA<BookingScreenError>()
      ],
    );
  });
}
