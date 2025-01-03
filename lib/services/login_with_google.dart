import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../repositories/wallet_repository.dart';

class LoginWithGoogle {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserProvider _userProvider = UserProvider();

  // Tạo tài liệu người dùng trong Firestore nếu chưa có
  Future<void> _createUserDocument(User? user) async {
    if (user == null) return;

    final userDoc = _firestore.collection('users').doc(user.uid);
    if (!(await userDoc.get()).exists) {
      await userDoc.set({
        'username': user.email?.split('@')[0] ?? '',
        'email': user.email,
        'phone': '',
        'userImg': user.photoURL ?? '',
        'userDeviceToken': '',
        'country': '',
        'userAddress': '',
        'isAdmin': false,
        'isActive': true,
        'createdOn': DateTime.now(),
        'city': '',
        'vehicle': '',
      });
    }
  }

  // Lấy thông tin người dùng từ Firestore và tạo UserModel
  Future<UserModel?> _getUserModel(User? user) async {
    if (user == null) return null;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();

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
        vehicle: userData['vehicle'] ?? '',
      );
    } else {
      return null;
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      // Khởi tạo GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Nếu người dùng hủy quá trình đăng nhập
      if (googleUser == null) {
        throw 'Google Sign-In was canceled.';
      }

      // Lấy thông tin chứng thực Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo thông tin đăng nhập Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Kiểm tra nếu tài khoản mới cần tạo tài liệu trong Firestore
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        await _createUserDocument(userCredential.user);

      }

      // Lấy thông tin người dùng từ Firestore
      UserModel? model = await _getUserModel(userCredential.user);
      await _userProvider.login(model!);

      // Nếu là người dùng mới, tạo ví cho họ
      if (isNewUser) {
        WalletModel walletModel = WalletModel(
          walletCode:
              model.username == '' ? "${model.username}BCP" : model.email,
          userID: model.userID,
          userName: model.username == '' ? model.username : 'NoName',
          balance: 0,
          creditScore: 0,
          isAction: true,
          createdOn: Timestamp.now(),
        );

        WalletRepository walletRepository = WalletRepository();
        await walletRepository.addWallet(model.userID, walletModel);
      }

      // Trả về thông tin người dùng
      return model;
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi đăng nhập Firebase Authentication
      if (e.code == 'account-exists-with-different-credential') {
        throw 'The account already exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        throw 'The provided credential is invalid.';
      } else {
        throw 'Error signing in with Google: ${e.message}';
      }
    } catch (e) {
      // Bắt lỗi chung
      if (kDebugMode) {
        print('An unexpected error occurred: $e');
      }
      throw 'An unexpected error occurred: $e';
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _userProvider.logout(); // Đăng xuất khỏi UserProvider
  }

  // Lấy người dùng hiện tại
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
