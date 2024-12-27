import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_smart_parking_app/blocs/Order/Order_event.dart';
import 'package:project_smart_parking_app/blocs/order/order_bloc.dart';
import 'package:project_smart_parking_app/blocs/order/order_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';



// Mock repository
class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository mockTransactionRepository;
  late OrderScreenBloc orderBloc;

  // Dummy data
  final List<TransactionModel> mockTransactions = [
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
      transactionID: 2,
      transactionType: true,
    ),
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
      transactionID: 3,
      transactionType: true,
    ),
  ];

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    orderBloc = OrderScreenBloc(mockTransactionRepository);
  });

  tearDown(() {
    orderBloc.close();
  });

  group('OrderScreenBloc Tests', () {
    test('initial state is OrderScreenInitial', () {
      expect: () => [
        isA<OrderScreenInitial>()

      ];
    });

    blocTest<OrderScreenBloc, OrderScreenState>(
      'emits [OrderScreenLoading, OrderScreenLoaded] when SearchMyOrder succeeds with empty searchText',
      build: () {
        when(() => mockTransactionRepository.getTransactionsByUser('user1'))
            .thenAnswer((_) async => mockTransactions);
        return orderBloc;
      },
      act: (bloc) => bloc.add(SearchMyOrder('user1', '')),
      expect: () => [
        isA<OrderScreenLoaded>()

      ],
    );

    blocTest<OrderScreenBloc, OrderScreenState>(
      'emits [OrderScreenLoading, OrderScreenLoaded] when SearchMyOrder succeeds with searchText',
      build: () {
        when(() => mockTransactionRepository.getTransactionsByUser('user1'))
            .thenAnswer((_) async => mockTransactions);
        return orderBloc;
      },
      act: (bloc) => bloc.add(SearchMyOrder('user1', 'Spot A') as OrderScreenEvent),
      expect: () => [
        isA<OrderScreenLoaded>()

      ],
    );

    blocTest<OrderScreenBloc, OrderScreenState>(
      'emits [OrderScreenLoading, OrderScreenError] when repository throws an exception',
      build: () {
        when(() => mockTransactionRepository.getTransactionsByUser('user1'))
            .thenThrow(Exception('Failed to load transactions'));
        return orderBloc;
      },
      act: (bloc) => bloc.add(SearchMyOrder('user1', '')),
      expect: () => [
        isA<OrderScreenError>()

      ],
    );
  });
}
