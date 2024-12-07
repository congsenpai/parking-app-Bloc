
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';



class HeaderText extends StatefulWidget {
  final String textInSpan1;
  final String textInSpan2;

  const HeaderText({
    super.key,
    required this.textInSpan1,
    required this.textInSpan2
  });

  @override
  State<HeaderText> createState() => _HeaderTextState();
}

class _HeaderTextState extends State<HeaderText> {


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [



        Padding(
          padding: EdgeInsets.only(left: Get.width / 25),
          child: RichText(
            text:  TextSpan(
              children: [
                TextSpan(
                  text: "${widget.textInSpan1}\n",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: "   ${widget.textInSpan2}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.only(right: Get.width / 15),
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 1),
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              foregroundColor: Colors.blue,
            ),
            child: const Text(
              'View All',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}