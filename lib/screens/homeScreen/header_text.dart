
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

      ],
    );
  }
}