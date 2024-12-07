import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/blocs/Order/Order_event.dart';
import 'package:project_smart_parking_app/blocs/order/order_bloc.dart';
import 'package:project_smart_parking_app/blocs/order/order_state.dart';
import 'package:project_smart_parking_app/screens/homeScreen/home_screen.dart';
import 'package:project_smart_parking_app/widget/footer_widget.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../models/user_model.dart';
import '../../widget/transaction_item_widget.dart';
import '../loginScreen/login_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool _isSearching = false; // Trạng thái hiển thị ô tìm kiếm
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  String userIDtest = 'AmBtXnoNWVfM3gxmNzFVQSu6y8p1';
  late List<TransactionModel> depositTransactions = [];
  late List<TransactionModel> withdrawTransactions = [];

  @override
  void initState() {
    super.initState();
    context.read<OrderScreenBloc>().add(SearchMyOrder(userIDtest, _searchText));
    // Lắng nghe sự thay đổi của TextField
    _searchController.addListener(() {
      _searchText = _searchController.text; // Cập nhật giá trị nhập
      // Xử lý dữ liệu tìm kiếm tại đây (ví dụ: gọi API hoặc lọc danh sách)
      print("Search Text: $_searchText");
      context
          .read<OrderScreenBloc>()
          .add(SearchMyOrder(userIDtest, _searchText));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderScreenBloc, OrderScreenState>(
        builder: (context, state) {
      if (state is OrderScreenLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is OrderScreenLoaded) {
        depositTransactions = state.depositdata;
        withdrawTransactions = state.withdrawdata;
      }
      return Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                )
              : const Text(
                  'My Orders',
                  style: TextStyle(color: Colors.black),
                ),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching; // Đổi trạng thái khi bấm nút
                  if (!_isSearching) {
                    _searchController
                        .clear(); // Xóa nội dung TextField khi đóng tìm kiếm
                  }
                });
              },
            ),
          ],
        ),
        body: depositTransactions != [] || withdrawTransactions != []
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap:
                          true, // Để ListView không chiếm hết không gian
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                      itemCount: depositTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = depositTransactions[index];
                        return SizedBox(
                          width: Get.width / 2,
                          child: TransactionItem(
                            icon: Icons.location_on,
                            // title: transaction.spotName, // Cần thay bằng thông tin từ transaction
                            // subtitle: '${transaction.total} VND', // Hiển thị thông tin giao dịch
                            // date: transaction.date.toDate().toString(), // Bạn có thể thay bằng ngày trong transaction
                            iconColor: Colors.green,
                            data: transaction, // Màu của icon tùy chỉnh
                          ),
                        );
                      },
                    ),
                    ListView.builder(
                      shrinkWrap:
                          true, // Để ListView không chiếm hết không gian
                      padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                      itemCount: withdrawTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = withdrawTransactions[index];
                        return SizedBox(
                          width: Get.width / 2,
                          child: TransactionItem(
                            icon: Icons.location_on,
                            data: transaction,
                            // title: transaction.spotName, // Cần thay bằng thông tin từ transaction
                            // subtitle: '${transaction.total} VND', // Hiển thị thông tin giao dịch
                            // date: transaction.date.toDate().toString(), // Bạn có thể thay bằng ngày trong transaction
                            iconColor: Colors.red, // Màu của icon tùy chỉnh
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : const Center(
                child: NoDataTransactionWidget(),
              ),
        bottomNavigationBar: const footerWidget(),
        backgroundColor: Colors.white,
      );
    }, listener: (context, state) {
      if (state is OrderScreenError) {
        OrderScreenError('Loading Fail');
      }
    });
  }
}

class NoDataTransactionWidget extends StatelessWidget {
  const NoDataTransactionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.chat_bubble_outline,
          size: 100,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 20),
        const Text(
          'No Orders Found',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'You have no orders data at this moment\nand perhaps you can start booking',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            final userModel =
                await Provider.of<UserProvider>(context, listen: false)
                    .loadUser();

            if (userModel != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(user: userModel)),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text(
            'Book Parking Spot',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
