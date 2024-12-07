import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';

import 'models/transaction_model.dart';


class TransactionListScreen extends StatefulWidget {
  final String userID;

  const TransactionListScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final TransactionRepository _repository = TransactionRepository();
  late Future<List<TransactionModel>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu giao dịch khi khởi tạo
    _transactionsFuture = _repository.getTransactionsByUser(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction List'),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found'));
          } else {
            // Hiển thị danh sách giao dịch
            List<TransactionModel> transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text('Transaction ID: ${transaction.transactionID}'),
                  subtitle: Text('Total: \$${transaction.total.toStringAsFixed(2)}'),
                  trailing: Text(transaction.transactionType ? 'Success' : 'Failed'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
