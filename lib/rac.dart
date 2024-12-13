import 'package:flutter/material.dart';

import 'package:project_smart_parking_app/repositories/wallet_repository.dart';
import 'models/wallet_model.dart'; // Ensure WalletModel is imported properly.



class WalletTestWidget extends StatefulWidget {
  final String walletCode; // Wallet code to search

  const WalletTestWidget({Key? key, required this.walletCode})
      : super(key: key);

  @override
  _WalletTestWidgetState createState() => _WalletTestWidgetState();
}

class _WalletTestWidgetState extends State<WalletTestWidget> {
  final WalletRepository _repository = WalletRepository();
  WalletModel? _wallet;
  bool _isLoading = true; // Loading state
  String? _error; // Error message

  @override
  void initState() {
    super.initState();
    _fetchWalletData();
  }

  Future<void> _fetchWalletData() async {
    try {
      WalletModel? wallet = await _repository.getWallet(widget.walletCode);
      setState(() {
        _wallet = wallet;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load wallet data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Wallet Data'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!)) // Show error if any
          : _wallet != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallet Code: ${_wallet!.walletCode}',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('User ID: ${_wallet!.userID}'),
            const SizedBox(height: 8),
            Text('User Name: ${_wallet!.userName}'),
            const SizedBox(height: 8),
            Text('Balance: \$${_wallet!.balance.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
                'Credit Score: ${_wallet!.creditScore.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
                'Is Active: ${_wallet!.isAction ? "Yes" : "No"}'),
            const SizedBox(height: 8),
            Text('Created On: ${_wallet!.createdOn.toDate()}'),
          ],
        ),
      )
          : const Center(child: Text('No data to display')),
    );
  }
}
