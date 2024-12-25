import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class GridMenuScreen extends StatelessWidget {
  late final String userID;
  late final UserModel userModel;

  GridMenuScreen({
    super.key,
    required this.userID,
    required this.userModel,
  });

  final List<Map<String, dynamic>> menuItems = [
    {
      "icon": 'assets/icons/icon_vip/03.png', // Đường dẫn đến ảnh của bạn
      "label": "E-Wallet",
      "onPress": () {
        print("E-Wallet được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/51.png',
      "label": "Dashboard",
      "onPress": () {
        print("Dashboard được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/06.png',
      "label": "Monthly Package",
      "onPress": () {
        print("Monthly Package được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/56.png',
      "label": "ChatBot",
      "onPress": () {
        print("ChatBot được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/58.png',
      "label": "Support",
      "onPress": () {
        print("Support được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/41.png',
      "label": "Cinema",
      "onPress": () {
        print("Cinema được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/38.png',
      "label": "Bus Monthly Ticket",
      "onPress": () {
        print("Bus Monthly Ticket được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/48.png',
      "label": "4G",
      "onPress": () {
        print("4G được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/28.png',
      "label": "Phone top up",
      "onPress": () {
        print("Phone top up được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/13.png',
      "label": "Fingerprint",
      "onPress": () {
        print("Fingerprint được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/25.png',
      "label": "Savings",
      "onPress": () {
        print("Savings được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/30.png',
      "label": "Gift",
      "onPress": () {
        print("Gift được chọn");
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10, // Khoảng cách giữa các mục theo chiều ngang
      runSpacing: 10, // Khoảng cách giữa các mục theo chiều dọc
      alignment: WrapAlignment.start,
      children: menuItems.map((item) {
        return SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width / 3 - 15, // Đặt chiều rộng mỗi mục
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: item["onPress"],
                iconSize: 50,
                icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color.fromARGB(139, 233, 245, 251),
                  child: Image.asset(
                    item["icon"],
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item["label"],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
