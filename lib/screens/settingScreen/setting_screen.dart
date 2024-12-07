import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsSection extends StatefulWidget {
  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue[100],
            child: Icon(Icons.person, size: 40, color: Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            '6281092102910',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                SettingsItem(
                  icon: Icons.person,
                  title: 'Edit Profile',
                ),
                SettingsItem(
                  icon: Icons.language,
                  title: 'App Language',
                ),
                SettingsItem(
                  icon: Icons.account_balance_wallet,
                  title: 'My Wallet',
                ),
                SettingsItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                ),
                SettingsItem(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                SettingsItem(
                  icon: Icons.help,
                  title: 'Contact & Help',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  SettingsItem({
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.blue),
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (trailing != null) trailing!,
          if (trailing == null) Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}