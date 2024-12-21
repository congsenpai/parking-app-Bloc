import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class LoginWithEmail {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserProvider _userProvider = UserProvider();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Đăng ký (Sign Up) ---

  // Tạo tài liệu cho người dùng mới
  Future<void> createUserDocument(User? user) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    if (!(await userDoc.get()).exists) {
      await userDoc.set({
        'username': user.email?.split('@')[0] ?? '',
        'email': user.email,
        'phone': '',
        'userImg': '',
        'userDeviceToken': '',
        'country': '',
        'userAddress': '',
        'isAdmin': false,
        'isActive': true,
        'createdOn': DateTime.now(),
        'city': '',
        'vehical': [],
      });
    }
  }

  // Đăng ký người dùng mới
  Future<UserModel?> signUpWithEmailPassword(String email, String password) async {
    try {
      // Tạo tài khoản người dùng mới
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tạo tài liệu cho người dùng trong Firestore
      await createUserDocument(userCredential.user);

      // Lấy thông tin người dùng từ Firestore
      UserModel? model = await _getUserModel(userCredential.user);
      await _userProvider.login(model!);
      // Trả về thông tin người dùng nếu đăng ký thành công
      return model;

    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi đăng ký Firebase Authentication
      if (e.code == 'weak-password') {
        // Trả về thông báo hoặc lỗi nếu cần thiết
        throw 'The password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        // Trả về thông báo hoặc lỗi nếu cần thiết
        throw 'The email is already in use.';
      } else if (e.code == 'invalid-email') {
        throw 'Invalid email address.';
      }
      // Xử lý các lỗi khác
      else {
        throw 'Error signing up: ${e.message}';
      }
    } catch (e) {
      // Bắt lỗi chung
      if (kDebugMode) {
        print('An unexpected error occurred: $e');
      }
      throw 'An unexpected error occurred: $e';
    }
  }


  // --- Đăng nhập (Sign In) ---

  // Đăng nhập với email và mật khẩu
  Future<UserModel?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel? model = await _getUserModel(userCredential.user);
      await _userProvider.login(model!);

      return model; // Trả về thông tin người dùng nếu đăng nhập thành công

    } catch (e) {
      return null; // Return null if an error occurs
    }
  }

  // --- Helper method để lấy thông tin người dùng từ Firestore ---

  // Lấy thông tin UserModel từ Firestore
  Future<UserModel?> _getUserModel(User? user) async {
    if (user == null) return null;

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return UserModel(
        userID: user.uid,
        username: userData['username'] ?? '',
        email: userData['email'] ?? '',
        phone: userData['phone'] ?? '',
        userImg: userData['userImg'] ?? '',
        userDeviceToken: userData['userDeviceToken'] ?? '',
        country: userData['country'] ?? '',
        userAddress: userData['userAddress'] ?? '',
        isAdmin: userData['isAdmin'] ?? false,
        isActive: userData['isActive'] ?? true,
        createdOn: userData['createdOn'] ?? DateTime.now(),
        city: userData['city'] ?? '',
        vehical: List<Map<String, String>>.from(userData['vehical'] ?? []),
      );
    } else {
      return null;
    }
  }

  // --- Đăng xuất ---
  Future<void> signOut() async {
    await _auth.signOut();
    await _userProvider.logout();
  }

  // --- Lấy thông tin người dùng hiện tại ---
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
