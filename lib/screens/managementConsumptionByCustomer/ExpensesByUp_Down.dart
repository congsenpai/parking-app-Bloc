import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ExpensesByUp_Down extends StatelessWidget {
  final double Blance;
  final String Title;
  final Color color;
  const ExpensesByUp_Down({super.key, required this.Blance, required this.Title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width/2.4,
      height: Get.width/4,
      padding: EdgeInsets.all(Get.width/60),
      margin: EdgeInsets.all(Get.width/30),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3), // Màu bóng, điều chỉnh độ mờ ở đây
            offset: Offset(2, 2), // Vị trí bóng (x, y)
            blurRadius: 5, // Độ mờ của bóng
            spreadRadius: 2, // Độ lan rộng của bóng
          ),
        ],

      ),
      child: Column(
        children: [

          Center(child: Text('$Title', style: TextStyle(fontSize: Get.width/20, fontWeight: FontWeight.bold, color: Colors.black),)),
          SizedBox(height: Get.width/30,),
          Container(
            decoration: BoxDecoration(
              color: color,

              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3), // Màu bóng, điều chỉnh độ mờ ở đây
                  offset: Offset(2, 2), // Vị trí bóng (x, y)
                  blurRadius: 5, // Độ mờ của bóng
                  spreadRadius: 2, // Độ lan rộng của bóng
                ),
              ],

            ),

            height: Get.width/10,
            child: Center(
              child: Text('$Blance', style: TextStyle(fontSize: Get.width/20, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}