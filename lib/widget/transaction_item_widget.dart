import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class TransactionItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;
  final Color iconColor;

  TransactionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.iconColor,
  });
  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
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
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                widget.subtitle,
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                widget.date,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(width: Get.width/20,),
          ElevatedButton(onPressed: (){}, child: Text('Chi tiết'))
        ],
      ),
    );
  }
}