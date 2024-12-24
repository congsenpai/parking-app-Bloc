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
import '../transactionDiposited/transaction_diposited.dart';

class WalletScreen extends StatefulWidget {
  final String userID;
  final String userName2;
  final double money = 0;
  final String userName = 'bao';
  final creditID = '00000000000';
  const WalletScreen({super.key,required this.userID, required this.userName2});
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
                        ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ...transactionModel.map((transaction) {
                            return SizedBox(
                              width: Get.width / 1.1,
                              child: TransactionItem(
                                icon: Icons.location_on,
                                data: transaction,
                                iconColor: transaction.transactionType?Colors.green:Colors.red,
                              ),
                            );
                          }).toList(),
                          SizedBox(height: Get.width/30,)
                        ],
                      ),
                    )
                        : const Center(child: Text("Chưa có giao dịch nào")),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:  footerWidget(userID: widget.userID, userName: widget.userName2,),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(widget.userName, style: TextStyle(color: Colors.white,fontSize: Get.width/25)),
                    Text(widget.creditID, style: TextStyle(color: Colors.white,fontSize: Get.width/25)),
                  ],
                ),

                Center(
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TransferFormScreen(userName: widget.userName, userID: widget.userID,)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Màu nền
                        foregroundColor: Colors.white, // Màu chữ
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                        shape: RoundedRectangleBorder(
                          side: BorderSide( // Viền
                            color: Colors.white, // Màu viền
                            width: 4,           // Độ dày viền
                          ),// Bo tròn nút
                          borderRadius: BorderRadius.circular(Get.width/20),
                        ),
                      ),
                      child: Text('Recharge',style: TextStyle(fontSize: Get.width/20),)
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
                      MaterialPageRoute(builder: (context) => MyOrdersScreen(userID: widget.userID, userName: widget.userName,))
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


