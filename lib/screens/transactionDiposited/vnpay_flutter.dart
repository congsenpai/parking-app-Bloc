import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin_ios_android/flutter_webview_plugin_ios_android.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../repositories/transaction_repository.dart';
import '../../repositories/wallet_repository.dart';
import '../walletScreen/wallet_screen.dart';

//[VNPayHashType] List of Hash Type in VNPAY, default is HMACSHA512
enum VNPayHashType {
  SHA256,
  HMACSHA512,
}

//[BankCode] List of valid payment bank in VNPAY, if not provide, it will be manual select, default is null
enum BankCode { VNPAYQR, VNBANK, INTCARD }

//[VNPayHashTypeExt] Extension to convert from HashType Enum to valid string of VNPAY
extension VNPayHashTypeExt on VNPayHashType {
  String toValueString() {
    switch (this) {
      case VNPayHashType.SHA256:
        return 'SHA256';
      case VNPayHashType.HMACSHA512:
        return 'HmacSHA512';
    }
  }
}


//[VNPAYFlutter] instance class VNPAY Flutter
class VNPAYFlutter {

  static final VNPAYFlutter _instance = VNPAYFlutter();

    //[instance] Single Ton Init
  static VNPAYFlutter get instance => _instance;


  Map<String, dynamic> _sortParams(Map<String, dynamic> params) {
    final sortedParams = <String, dynamic>{};
    final keys = params.keys.toList()..sort();
    for (String key in keys) {
      sortedParams[key] = params[key];
    }
    return sortedParams;
  }


  //[generatePaymentUrl] Generate payment Url with input parameters
  String generatePaymentUrl({
    String url = 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    required String version,
    String command = 'pay',
    required String tmnCode,
    String locale = 'vn',
    String currencyCode = 'VND',
    required String txnRef,
    String orderInfo = 'Pay Order',
    required double amount,
    required String returnUrl,
    required String ipAdress,
    DateTime? createAt,
    required String vnpayHashKey,
    VNPayHashType vnPayHashType = VNPayHashType.HMACSHA512,
    String vnpayOrderType = 'other',
    BankCode? bankCode,
    required DateTime vnpayExpireDate,
  }) {
    final params = <String, String>{
      'vnp_Version': version,
      'vnp_Command': command,
      'vnp_TmnCode': tmnCode,
      'vnp_Locale': locale,
      'vnp_CurrCode': currencyCode,
      'vnp_TxnRef': txnRef,
      'vnp_OrderInfo': orderInfo,
      'vnp_Amount': (amount * 100).toStringAsFixed(0),
      'vnp_ReturnUrl': returnUrl,
      'vnp_IpAddr': ipAdress,
      'vnp_CreateDate': DateFormat('yyyyMMddHHmmss')
          .format(createAt ?? DateTime.now())
          .toString(),
      'vnp_OrderType': vnpayOrderType,
      'vnp_ExpireDate':
          DateFormat('yyyyMMddHHmmss').format(vnpayExpireDate).toString(),
    };
    if (bankCode != null) {
      params['vnp_BankCode'] = bankCode.name;
    }
    var sortedParam = _sortParams(params);
    final hashDataBuffer = StringBuffer();
    sortedParam.forEach((key, value) {
      hashDataBuffer.write(key);
      hashDataBuffer.write('=');
      hashDataBuffer.write(value);
      hashDataBuffer.write('&');
    });
    String hashData =
        hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
    String query = sortedParam.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&'); //Uri(host: url, queryParameters: sortedParam).query;
    String vnpSecureHash = "";

    if (vnPayHashType == VNPayHashType.SHA256) {
      List<int> bytes = utf8.encode(vnpayHashKey + hashData.toString());
      vnpSecureHash = sha256.convert(bytes).toString();
    } else if (vnPayHashType == VNPayHashType.HMACSHA512) {
      vnpSecureHash = Hmac(sha512, utf8.encode(vnpayHashKey))
          .convert(utf8.encode(hashData))
          .toString();
    }
    String paymentUrl =
        "$url?$query&vnp_SecureHashType=${vnPayHashType.toValueString()}&vnp_SecureHash=$vnpSecureHash";
    debugPrint("=====>[PAYMENT URL]: $paymentUrl");
    return paymentUrl;
  }

  //[show] show payment url and return result on callback
  Future<void> show({
    required double budget,
    required String userID,

    required String paymentUrl,
    Function(Map<String, dynamic>)? onPaymentSuccess,
    Function(Map<String, dynamic>)? onPaymentError,
    Function()? onWebPaymentComplete,
  }) async {
    if (kIsWeb) {
      await launchUrlString(
        paymentUrl,
        webOnlyWindowName: '_self',
      );
      if (onWebPaymentComplete != null) {
        onWebPaymentComplete();
      }
    } else {
      final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
      flutterWebviewPlugin.onUrlChanged.listen((url) async {
        if (url.contains('vnp_ResponseCode')) {
          final params = Uri
              .parse(url)
              .queryParameters;
          if (params['vnp_ResponseCode'] == '00') {
            if (onPaymentSuccess != null) {
              onPaymentSuccess(params);
              flutterWebviewPlugin.close();
              Get.to(WalletScreen(userID: userID, userName2: '',));

              double count = 0;
              TransactionRepository transactionRepository = TransactionRepository();
              WalletRepository walletRepository = WalletRepository();
              List<TransactionModel> tran = await transactionRepository
                  .getAllTransactions();
              count = tran.length + 1;
              TransactionModel transactionModel = TransactionModel
                (vehicalLicense: 'Recharged Money',
                  note: 'Recharged Money',
                  typeVehical: 'Recharged Money',
                  budget: 0,
                  date: Timestamp.now(),
                  endTime: Timestamp.now(),
                  slotName: 'Recharged Money',
                  spotName: 'Recharged Money',
                  startTime: Timestamp.now(),
                  total: budget,
                  totalTime: 0,
                  transactionID: count,
                  transactionType: true,
                  userID: userID);
              await transactionRepository.addTransaction(transactionModel);
              await walletRepository.updateWalletBalance(userID, budget);
            } else {
              if (onPaymentError != null) {
                onPaymentError(params);
              }
            }
            flutterWebviewPlugin.close();
          }
        }
      });
      flutterWebviewPlugin.launch(paymentUrl);
    }
  }
}
