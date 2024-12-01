import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';

class TransactionItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final TransactionModel data;

  TransactionItem({
    required this.icon,
    required this.iconColor,
    required this.data,
  });
  @override
  State<TransactionItem> createState() => _TransactionItemState();


}

class _TransactionItemState extends State<TransactionItem> {



  @override

  Widget build(BuildContext context) {
    final String title = widget.data.spotName;
    final String subtitle = '${widget.data.total} VND';
    final String date = widget.data.date.toDate().toString();
    return Container(
      width: Get.width/1.4,
      height: Get.width/4,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: widget.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(widget.icon, color: widget.iconColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                date,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(width: Get.width/20,),
          ElevatedButton(onPressed: (){

          },
              child: Text('Chi tiết')
          )
        ],
      ),
    );
  }
}