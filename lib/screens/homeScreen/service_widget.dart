import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/screens/chatBotService/GeminiScreen.dart';
import 'package:project_smart_parking_app/screens/managementConsumptionByCustomer/management_consumption_by_customer.dart';
import 'package:project_smart_parking_app/screens/monthlyParkage/ChoosendSpots.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';
import '../../models/user_model.dart';

class GridMenuScreen extends StatelessWidget {
  late final String userID;
  late final UserModel userModel;

  GridMenuScreen({
    super.key,
    required this.userID,
    required this.userModel,
  });

  late final List<Map<String, dynamic>> menuItems = [
    {
      "icon": 'assets/icons/icon_vip/03.png',
      "label": "E-Wallet",
      "onPress": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WalletScreen(userID: userID, userName2: userModel.username),
          ),
        );
      }
    },
    {
      "icon": 'assets/icons/icon_vip/51.png',
      "label": "Dashboard",
      "onPress": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ManagementConsumptionByCustomer(userID: userID),
          ),
        );
      }
    },
    {
      "icon": 'assets/icons/icon_vip/06.png',
      "label": "Monthly Package",
      "onPress": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChoosendSpots(userModel: userModel),
          ),
        );
      }
    },
    {
      "icon": 'assets/icons/icon_vip/56.png',
      "label": "ChatBot",
      "onPress": (BuildContext context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(title: 'Chat Bot'),
          ),
        );
      }
    },
    {
      "icon": 'assets/icons/icon_vip/58.png',
      "label": "Support",
      "onPress": (BuildContext context) {
        print("Support được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/41.png',
      "label": "Cinema",
      "onPress": (BuildContext context) {
        print("Cinema được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/38.png',
      "label": "Bus Monthly Ticket",
      "onPress": (BuildContext context) {
        print("Bus Monthly Ticket được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/48.png',
      "label": "4G",
      "onPress": (BuildContext context) {
        print("4G được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/28.png',
      "label": "Phone top up",
      "onPress": (BuildContext context) {
        print("Phone top up được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/13.png',
      "label": "Fingerprint",
      "onPress": (BuildContext context) {
        print("Fingerprint được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/25.png',
      "label": "Savings",
      "onPress": (BuildContext context) {
        print("Savings được chọn");
      }
    },
    {
      "icon": 'assets/icons/icon_vip/30.png',
      "label": "Gift",
      "onPress": (BuildContext context) {
        print("Gift được chọn");
      }
    },
    // Other menu items remain unchanged...
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: menuItems.map((item) {
        return SizedBox(
          width: MediaQuery.of(context).size.width / 3 - 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => item["onPress"](context), // Pass context
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
