import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_smart_parking_app/models/wallet_model.dart';

class WalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<WalletModel?> getWallet(String userID) async {
    try {
      // Access the document based on userID
      DocumentSnapshot snapshot = await _firestore
          .collection('Wallet')
          .doc(userID)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        // Convert DocumentSnapshot data to WalletModel
        final Map<String, dynamic> data =
        snapshot.data() as Map<String, dynamic>;
        final WalletModel walletData = WalletModel.fromJson(data);
        return walletData;
      } else {
        print('Wallet not found for userID: $userID');
        return null;
      }
    } catch (e) {
      print('Error fetching wallet data: $e');
      return null;
    }
  }
}
