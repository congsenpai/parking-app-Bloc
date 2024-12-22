// ignore_for_file: unused_import

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_event.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/models/wallet_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';



class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository walletRepository;
  final TransactionRepository transactionRepository;


  WalletBloc(this.walletRepository, this.transactionRepository)
      : super(WalletInitial()) {
    on<GetDataWalletEvent>(_GetDataWallet);
  }

  // Định nghĩa lại hàm _WalletLoading với đúng cú pháp và kiểu trả về
  Future<void> _GetDataWallet(GetDataWalletEvent event,
      Emitter<WalletState> emit) async {
    // emit(WalletLoading());
    try {
      final WalletModel WalletData;
      WalletData = (await walletRepository.getWallet(event.userID))!;
      final List<TransactionModel> TransactionData;
      TransactionData = await transactionRepository.getRecentlyTransactionsByUser(event.userID);
      emit(WalletLoaded(TransactionData, WalletData));

    } catch (e) {
      emit(WalletError("Failed to load parking spots"));
    }
  }
  }




