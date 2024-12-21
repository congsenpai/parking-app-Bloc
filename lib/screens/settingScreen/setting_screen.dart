import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/screens/settingScreen/update_user_profile.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';
import 'package:project_smart_parking_app/widget/footer_widget.dart';


class SettingsScreen extends StatefulWidget {
  @override
  const SettingsScreen({super.key, required this.userID, required this.userName});
  final String userID;
  final String userName;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Avatar và số điện thoại
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children:  [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  "${widget.userName}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Các mục trong Settings
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: Get.width/10),
              padding: EdgeInsets.only(right :Get.width/20, left: Get.width/20),
              child: Column(
                  children: [
                    // edit profile
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white60,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: buildListTile(Icons.edit, "Edit Profile", onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>UpdateUserProfile(UserID: widget.userID,)));
                      }),
                    ),
                    SizedBox(
                      height: Get.width /20,
                    ),
                    // app language
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: buildListTile(Icons.language, "App Language", onTap: () {}),
                    ),
                    SizedBox(
                      height: Get.width /20,
                    ),
                    // My Wallet
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: buildListTile(Icons.wallet, "My wallet", onTap: () {
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)=> WalletScreen(userID: widget.userID, userName2: widget.userName,)));
                      }),
                    ),
                    SizedBox(
                      height: Get.width /20,
                    ),
                    // Notifications
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: buildListTile(Icons.notifications, "Notifications", onTap: () {}),
                    ),
                    SizedBox(
                      height: Get.width /20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: buildSwitchTile("Dark Mode", false),
                    ),
                    SizedBox(
                      height: Get.width /20,
                    ),
                    // contact and help
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white60,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: buildListTile(Icons.help, "Contact & Help", onTap: () {}),
                    ),
                  ],
              ),
            ),
          )
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: footerWidget(userID: widget.userID, userName: widget.userName,),
    );
  }

  // Widget cho mỗi mục ListTile
  ListTile buildListTile(IconData icon, String title,
      {required VoidCallback onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Widget cho mục Dark Mode với Switch
  SwitchListTile buildSwitchTile(String title, bool value) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      value: value,
      onChanged: (bool newValue) {
        // Handle toggle logic here
      },
      activeColor: Colors.blueAccent,
    );
  }
}