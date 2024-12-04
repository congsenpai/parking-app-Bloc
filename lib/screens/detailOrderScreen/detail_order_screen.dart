import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_bloc.dart';
import 'package:project_smart_parking_app/blocs/detailOrder/detail_order_state.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';

import '../../blocs/detailOrder/detail_order_event.dart';

class OrderDetailsScreen extends StatefulWidget {
  @override
  const OrderDetailsScreen({super.key, required this.transactionID});
  final String transactionID;
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();


}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  late TransactionModel _transactionModel =TransactionModel
    (vehicalLicense: '',
      note: '',
      typeVehical: '',
      budget: 0,
      date: Timestamp.fromDate(DateTime.now()),
      endTime: Timestamp.fromDate(DateTime.now()) ,
      slotName: '',
      spotName: '',
      startTime: Timestamp.fromDate(DateTime.now()),
      total: 0,
      totalTime: 0,
      transactionID: 1,
      transactionType: true,
      userID: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<OrderDetailScreenBloc>().add(
        OrderDetailEvent(widget.transactionID)
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderDetailScreenBloc,OrderDetailScreenState>(builder: (context,state){
      if(state is OrderDetailScreenLoading){
        return Center(child: CircularProgressIndicator(),);
      }
      else if(state is OrderDetailScreenLoaded){
        _transactionModel = state.transactionModel;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text('Mã giao dịch ${_transactionModel.transactionID.toString()}',
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),

        body: Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.blue.shade100,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          margin: EdgeInsets.all(Get.width/20),
          padding: EdgeInsets.all(Get.width/20),
          child: SingleChildScrollView(
            child: Table(

              // Định nghĩa các độ rộng cột
              columnWidths: const {
                0: FlexColumnWidth(1), // Cột 0 có chiều rộng cố định 100
                1: FlexColumnWidth(1),    // Cột 1 chiếm gấp đôi không gian so với các cột flex khác
                  // Cột 2 chiếm không gian bằng 1 flex
              },
              // Tạo viền cho bảng
              children: [
                // tên bãi đỗ
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Tên bãi đỗ ', textAlign: TextAlign.left,
                          style: TextStyle(
                          fontSize: Get.width/30,
                          color: Colors.black45,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                    ),

                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.spotName}', textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: Get.width/30,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                    ),
                  ],
                ),
                // loại phương tiện
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Loại phương tiện ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.typeVehical}', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
                // tên vị trí đỗ
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Tên vị trí đỗ  ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.slotName}', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
                // Biển số xe
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Biển số xe ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.vehicalLicense}', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
                // tổng thời gian
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Tổng thời gian ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.totalTime.toString()} h', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
                // giá gửi xe
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Giá gửi xe ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.budget.toString()} VNĐ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),
                // tổng tiền
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Tổng tiền ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(':  ${_transactionModel.total.toString()} VNĐ', textAlign: TextAlign.left,style: TextStyle(
                            fontSize: Get.width/30,
                            color: Colors.black45,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ],
                ),

              ],
            ),


          ),
        ),
      );
    }, listener: (context,state){
      if(state is OrderDetailScreenError){
        OrderDetailScreenError(
          'Do not have data'
        );
      }
    }
    );
  }
}
