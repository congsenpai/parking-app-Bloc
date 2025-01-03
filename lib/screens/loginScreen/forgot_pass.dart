// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/screens/loginScreen/login_screen.dart';
import 'package:project_smart_parking_app/services/forgot_pass.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();
  String tilte = 'Verify Account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF070201),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: constraints.maxHeight / 30),
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: Get.width / 2.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight / 12),
                      Center(
                        child: CircleAvatar(
                          radius: Get.width / 6,
                          child: const Icon(
                            Icons.verified_user_rounded,
                            size: 60,
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight / 45),
                      Center(
                        child: Text(
                          tilte,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 35,
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight / 35),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 4, right: 4),
                          child: Text(
                            "We will verify your account right now",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              decoration: TextDecoration.none,
                              color: Colors.white30,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 8,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color(0xFF2C2F3F),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: Get.height / 10),
                      ElevatedButton(
                        onPressed: () async {
                          EasyLoading.show(status: 'Verifying');

                          // Use async if needed, to handle the call properly
                          String? username = await _forgotPasswordService
                              .getUserByEmail(_emailController.text.trim());

                          // Check if the username is not null
                          if (username != null) {
                            await _forgotPasswordService
                                .resetPassword(_emailController.text.trim());

                            // Show success message
                            EasyLoading.showSuccess(
                              'Email sent successfully, please check your inbox',
                              duration: const Duration(seconds: 2),
                            );

                            // Navigate to the LoginScreen after success
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          } else {
                            // Dismiss the loading indicator and show an error dialog
                            EasyLoading.dismiss();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('This email is not registered'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4040FD),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height / 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
