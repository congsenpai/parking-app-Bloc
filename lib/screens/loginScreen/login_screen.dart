import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../homeScreen/home_screen.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../services/login_with_email.dart';
import '../../services/login_with_google.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project_smart_parking_app/blocs/auth/auth_event.dart';
import 'package:project_smart_parking_app/blocs/auth/auth_state.dart';
import 'package:project_smart_parking_app/services/login_with_otp.dart';
import 'package:project_smart_parking_app/screens/loginScreen/login_with_phone_number.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isChecked = false; // Variable to hold checkbox state
  bool obscureText = true; // Variable to toggle password visibility
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocProvider(
          create: (context) =>
              AuthBloc(LoginWithEmail(), LoginWithGoogle(), LoginWithOTP()),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                // Show loading indicator
                EasyLoading.show(status: 'Verifying...');
              } else if (state is AuthAuthenticated) {
                final user = state.user;
                EasyLoading.dismiss();
                Get.to(HomeScreen(user: user));
              } else if (state is AuthError) {
                EasyLoading.dismiss();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text(state.message),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            builder: (context, state) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title in a Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: Get.height / 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height / 20,
                      ),
                      const Text(
                        'Sign in to Parkiin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 40,
                      ),

                      // Email TextField
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
                      SizedBox(
                        height: Get.height / 40,
                      ),

                      // Password TextField with Visibility Toggle
                      TextField(
                        controller: _passwordController,
                        obscureText: obscureText,
                        // Use the obscureText variable
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: const Color(0xFF2C2F3F),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText; // Toggle the state
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: Get.height / 30,
                      ),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value:
                                    context.read<AuthBloc>().state.isRemember,
                                onChanged: (value) {
                                  if (value != null) {
                                    context
                                        .read<AuthBloc>()
                                        .add(ToggleRememberMeEvent(value));
                                    print('Đã checked');
                                  }
                                },
                                activeColor: Colors.blue,
                              ),
                              const Text(
                                'Remember Me',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Get.snackbar(
                                'Password Recovery',
                                'Link to reset password sent to your email!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black54,
                                colorText: Colors.white,
                              );
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),

                      // Sign In Button with GetX Navigation
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  LoginWithEmailEvent(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  ),
                                );
                            if (_errorMessage != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Lỗi'),
                                    content: Text(_errorMessage!),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white30,
                              padding: const EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2))),
                          child: const Text('Sign in',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 20,
                      ),

                      // Divider with "or"
                      const Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('or',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          Expanded(child: Divider(color: Colors.grey)),
                        ],
                      ),
                      SizedBox(
                        height: Get.height / 40,
                      ),

                      // Social Sign-In Buttons
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LoginWithGoogleEvent());
                          if (_errorMessage != null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Lỗi'),
                                  content: Text(_errorMessage!),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.white, width: 1),
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.g_mobiledata_rounded,
                                color: Colors.white),
                            Text('Sign in with google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 40,
                      ),

                      // Social Sign-In Buttons
                      ElevatedButton(
                        onPressed: () {
                          Get.to(LoginWithPhoneNumberScreen);
                        },
                        style: ElevatedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.white, width: 1),
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2))),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.white),
                            Text(
                              'Sign in with phone number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 40,
                      ),

                      // Sign Up Prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New to Parkiin?',
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to Sign Up Screen
                            },
                            child: const Text(
                              'Create new account here →',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ],
                      ),
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
