import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_smart_parking_app/models/transaction_model.dart';
import 'package:project_smart_parking_app/repositories/transaction_repository.dart';
import 'package:project_smart_parking_app/repositories/wallet_repository.dart';
import 'package:project_smart_parking_app/screens/transactionDiposited/vnpay_flutter.dart';
import 'package:project_smart_parking_app/screens/walletScreen/wallet_screen.dart';

import '../OrderScreen/order_screen.dart';
class TransferFormScreen extends StatefulWidget {

  final String userName;

  final String userID;

  const TransferFormScreen({super.key, required this.userName, required this.userID});
  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}
class _TransferFormScreenState extends State<TransferFormScreen> {
  String responseCode = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _paymentMethod; // Lưu phương thức thanh toán được chọn (MoMo hoặc VNPay)
  Future<void> onPayment(String orderInfo,double amount) async {
    final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
      url:
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html', //vnpay url, default is https://sandbox.vnpayment.vn/paymentv2/vpcpay.html
      version: '2.0.1',
      tmnCode: 'CVXOW51B', //vnpay tmn code, get from vnpay
      txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
      orderInfo: orderInfo, //order info, default is Pay Order
      amount: amount,
      returnUrl:
      'xxxxxx', //https://sandbox.vnpayment.vn/apis/docs/huong-dan-tich-hop/#code-returnurl
      ipAdress: '192.168.10.10',
      vnpayHashKey: 'WN9I2JRPC6ASCWQ1XS8C94WYEYJFCTR5', //vnpay hash key, get from vnpay
      vnPayHashType: VNPayHashType
          .HMACSHA512, //hash type. Default is HMACSHA512, you can chang it in: https://sandbox.vnpayment.vn/merchantv2,
      vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
    );
    await VNPAYFlutter.instance.show(
      paymentUrl: paymentUrl,
      onPaymentSuccess: (params) {
          setState(() {
            Navigator.pop(context); // Thoát màn hình hiện tại
            Navigator.push(context, MaterialPageRoute(builder: (context)=>WalletScreen(userID: widget.userID, userName2: widget.userName)));
          });
        },
      onPaymentError: (params) {
        setState(() {
          responseCode = 'Error';
        });
      }, budget: amount, userID: widget.userID
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin chuyển khoản'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Họ và tên
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Input Số tiền
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Số tiền',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Số tiền không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Ghi chú
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú (không bắt buộc)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Phương thức thanh toán
                const Text(
                  'Phương thức thanh toán:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RadioListTile<String>(
                  title: const Text('MoMo'),
                  value: 'MoMo',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('VNPay'),
                  value: 'VNPay',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Nút xác nhận
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_paymentMethod == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng chọn phương thức thanh toán'),
                            ),
                          );
                        } else {
                          _submitForm();
                        }
                      }
                    },
                    child: const Text('Xác nhận chuyển khoản'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    String name = _nameController.text;
    String amount = _amountController.text;
    String note = _noteController.text;
    String paymentMethod = _paymentMethod!;

    // Thực hiện logic xử lý dữ liệu (ví dụ: gọi API, hiển thị thông báo, v.v.)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thông tin'),
        content: Text(
          'Họ và tên: $name\n'
              'Số tiền: $amount VND\n'
              'Ghi chú: ${note.isNotEmpty ? note : 'Không có'}\n'
              'Phương thức thanh toán: $paymentMethod',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              onPayment('${name} '
                  'recharged ${amount} '
                  'with note ${note}',
                  double.parse(amount));
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
