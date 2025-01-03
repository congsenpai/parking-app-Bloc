// ignore_for_file: non_constant_identifier_names

import 'package:project_smart_parking_app/models/wallet_model.dart';

import '../../models/transaction_model.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  late final List<TransactionModel> Transactiondata;
  late final WalletModel dataWallet;
  WalletLoaded(this.Transactiondata, this.dataWallet);
}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}
