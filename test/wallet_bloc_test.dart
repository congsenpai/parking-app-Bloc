import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_bloc.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_event.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/models/wallet_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';

// Mock các repository
class MockWalletRepository extends Mock implements WalletRepository {}

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  group('WalletBloc', () {
    late MockWalletRepository mockWalletRepository;
    late MockTransactionRepository mockTransactionRepository;
    late WalletBloc walletBloc;

    // Dữ liệu giả cho test
    const String testUserID = '123';
    final WalletModel fakeWallet = WalletModel(

      balance: 1000.0, walletCode: '', userID: '', userName: '', creditScore: 0, isAction: true, createdOn: Timestamp.now(),
    );
    final List<TransactionModel> fakeTransactions = [
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
    ];

    setUp(() {
      mockWalletRepository = MockWalletRepository();
      mockTransactionRepository = MockTransactionRepository();
      walletBloc = WalletBloc(mockWalletRepository, mockTransactionRepository);
    });

    tearDown(() {
      walletBloc.close();
    });

    test('initial state is WalletInitial', () {
      () => [
        isA<WalletInitial>(),

      ];
    });

    blocTest<WalletBloc, WalletState>(
      'emits [WalletLoading, WalletLoaded] when GetDataWalletEvent is successful',
      build: () {
        when(() => mockWalletRepository.getWallet(testUserID))
            .thenAnswer((_) async => fakeWallet);
        when(() => mockTransactionRepository.getTransactionsByUser(testUserID))
            .thenAnswer((_) async => fakeTransactions);
        return walletBloc;
      },
      act: (bloc) => bloc.add(GetDataWalletEvent(testUserID)),
      expect: () => [
        isA<WalletLoaded>(),

      ],


    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletLoading, WalletError] when GetDataWalletEvent fails',
      build: () {
        when(() => mockWalletRepository.getWallet(testUserID))
            .thenThrow(Exception('Failed to fetch wallet'));
        when(() => mockTransactionRepository.getTransactionsByUser(testUserID))
            .thenThrow(Exception('Failed to fetch transactions'));
        return walletBloc;
      },
      act: (bloc) => bloc.add(GetDataWalletEvent(testUserID)),
      expect: () => [
        isA<WalletError>(),


      ],
    );

    blocTest<WalletBloc, WalletState>(
      'emits [WalletLoading, WalletError] when walletRepository returns null',
      build: () {
        when(() => mockWalletRepository.getWallet(testUserID))
            .thenAnswer((_) async => null);
        return walletBloc;
      },
      act: (bloc) => bloc.add(GetDataWalletEvent(testUserID)),
      expect: () => [
        isA<WalletError>(),

      ],
      verify: (_) {
        verify(() => mockWalletRepository.getWallet(testUserID)).called(1);
      },
    );
  });
}
