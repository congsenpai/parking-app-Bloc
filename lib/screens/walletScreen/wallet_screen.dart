import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_event.dart';
import 'package:project_smart_parking_app/blocs/wallet/wallet_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/models/wallet_model.dart';
import 'package:project_smart_parking_app/screens/OrderScreen/order_screen.dart';
import 'package:project_smart_parking_app/widget/footer_widget.dart';
import '../../blocs/wallet/wallet_bloc.dart';
import '../../widget/transaction_item_widget.dart';

class WalletScreen extends StatefulWidget {
  final String userID;
  final double money = 0;
  final String userName = 'bao';
  final creditID = '00000000000';
  const WalletScreen({super.key,required this.userID});
  @override
  State<WalletScreen> createState() => _WalletScreenState();

}
class _WalletScreenState extends State<WalletScreen> {
  late List<TransactionModel> transactionModel = [];
  late WalletModel walletModel = WalletModel(walletCode: '', userID: '', userName: '', balance: 0, creditScore: 0, isAction: true, createdOn: Timestamp.now());
  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(GetDataWalletEvent(widget.userID));
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc,WalletState>(
        builder:(context,state){
          if (state is WalletLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WalletLoaded) {
            if (state.Transactiondata.isEmpty) {
              return Center(child: Text('Chưa có giao dịch nào'));
            }
            transactionModel = state.Transactiondata;
            walletModel = state.dataWallet;
          } else if (state is WalletError) {
            return Center(child: Text('Đã xảy ra lỗi: ${state.message}'));
          }
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                              child: WalletSection(
                                money: walletModel.balance,
                                userName: walletModel.userName,
                                creditID: walletModel.walletCode, userID: walletModel.userID,

                            )
                          ),
                        ],
                      ),
                    ),
                    transactionModel.isNotEmpty
                        ? ListView.builder(
                          shrinkWrap: true, // Để ListView không chiếm hết không gian
                          padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
                          itemCount: transactionModel.length,
                          itemBuilder: (context, index) {
                            final transaction = transactionModel[index];
                            return SizedBox(
                              width: Get.width/2,
                              child: TransactionItem(
                                icon: Icons.location_on,
                                // title: transaction.spotName, // Cần thay bằng thông tin từ transaction
                                // subtitle: '${transaction.total} VND', // Hiển thị thông tin giao dịch
                                // date: transaction.date.toDate().toString(), // Bạn có thể thay bằng ngày trong transaction
                                iconColor: transaction.transactionType == false ? Colors.red : Colors.blue, data: transaction, // Màu của icon tùy chỉnh
                              ),
                            );
                          },
                        )
                        : const Center(child: Text("Chưa có giao dịch nào")),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const footerWidget(),
          );
        },
        listener: (context,state){
        }
    );
  }
}
class WalletSection extends StatefulWidget {
  final double money;
  final String userName;
  final String creditID;
  final String userID;

  const WalletSection({super.key, required this.money, required this.userName, required this.creditID, required this.userID});

  @override
  State<WalletSection> createState() => _WalletSectionState();
}

class _WalletSectionState extends State<WalletSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(Get.width/30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Wallet',
                style: TextStyle(fontSize: Get.width/20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: Get.width/20),
          Container(
            width: Get.width/1.1,
            height: Get.width/2.5,
            padding: EdgeInsets.all(Get.width/20),
            decoration: BoxDecoration(
              color: Colors.indigo[900],

              image: const DecorationImage(
                image: AssetImage('assets/images/backgroundCreditCard.png'),
                fit: BoxFit.cover, // Để hình nền phủ kín vùng container
              ),
              borderRadius: BorderRadius.circular(Get.width/20),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.money.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Get.width/15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Get.width/20),
                    Text(widget.userName, style: const TextStyle(color: Colors.white)),
                    Text(widget.creditID, style: const TextStyle(color: Colors.white)),
                  ],
                ),

                Center(
                  child: ElevatedButton(
                      onPressed: (){},
                      child: const Text('Nạp tiền')
                  )
                )
              ],
            ),
          ),
          SizedBox(height: Get.width/10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Transactions',
                style: TextStyle(fontSize: Get.width/20, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: Get.width/5),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyOrdersScreen())
                  );
                },

                child: Text(
                  'View All',
                  style: TextStyle(color: Colors.blue, fontSize: Get.width/25),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


