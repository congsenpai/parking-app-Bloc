import 'package:flutter/material.dart';
class TransferFormScreen extends StatefulWidget {
  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}
class _TransferFormScreenState extends State<TransferFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _paymentMethod; // Lưu phương thức thanh toán được chọn (MoMo hoặc VNPay)
  @override
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
              Navigator.pop(context);
              // Xử lý logic chuyển khoản tại đây
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
