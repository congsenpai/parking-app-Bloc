import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Check if email exists in Firestore and return username if found
  Future<String?> getUserByEmail(String email) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        return userDoc.docs[0]['username'];
      }
      return null;
    } catch (e) {
      EasyLoading.showError('Error fetching username: $e');
      return null;
    }
  }

// function to update the password
  Future<bool> updatePassword(
      String email, String newPassword, String currentPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.email == email) {
        // Reauthenticate with the correct current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: currentPassword, // Use the actual current password
        );
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);
        EasyLoading.showSuccess('Password updated successfully.');
        return true;
      } else {
        EasyLoading.showError('User not found or incorrect email.');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error updating password: $e');
      return false;
    }
  }

// function to reset the password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      EasyLoading.showSuccess('Password reset email sent.');
      return true;
    } catch (e) {
      EasyLoading.showError('Error sending password reset email: $e');
      return false;
    }
  }

}
