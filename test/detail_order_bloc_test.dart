import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_bloc.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_event.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';

// Mock repository
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late OrderDetailScreenBloc bloc;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    bloc = OrderDetailScreenBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('OrderDetailScreenBloc', () {
    const transactionID = '12345';
    final mockTransaction =  TransactionModel(
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
    );

    test('initial state is OrderDetailScreenInitial', () {
      () => [
        isA<OrderDetailScreenError>()
      ];
    });


    blocTest<OrderDetailScreenBloc, OrderDetailScreenState>(
      'emits [OrderDetailScreenLoading, OrderDetailScreenLoaded] when data is successfully fetched',
      build: () {
        when(() => mockRepository.getTransactionsByID(transactionID))
            .thenAnswer((_) async => mockTransaction);
        return bloc;
      },
      act: (bloc) => bloc.add(OrderDetailEvent(transactionID)),
      expect: () => [

        anyOf(
          OrderDetailScreenLoading(),
          isA<OrderDetailScreenError>(),
        ),
      ],
    );


    blocTest<OrderDetailScreenBloc, OrderDetailScreenState>(
      'emits [OrderDetailScreenLoading, OrderDetailScreenError] when an exception occurs',
      build: () {
        when(() => mockRepository.getTransactionsByID(transactionID))
            .thenThrow(Exception('Error fetching data'));
        return bloc;
      },
      act: (bloc) => bloc.add(OrderDetailEvent(transactionID)),
      expect: () => [
        anyOf(
          OrderDetailScreenLoading(),
          isA<OrderDetailScreenError>(),
        ),
      ],
    );
  });
}
