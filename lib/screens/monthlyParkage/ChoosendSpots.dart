import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/models/parking_spot_model.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/repositories/parking_spot_repository.dart';

import '../../widget/spot_item_widget.dart';

class ChoosendSpots extends StatefulWidget {
  final UserModel userModel;
  const ChoosendSpots({super.key, required this.userModel});

  @override
  State<ChoosendSpots> createState() => _ChoosendSpotsState();
}

class _ChoosendSpotsState extends State<ChoosendSpots> {
  List<ParkingSpotModel> _parkingSpots = [];
  bool _isLoading = true; // Thêm trạng thái để hiển thị khi đang tải dữ liệu.

  @override
  void initState() {
    super.initState();
    _loadParkingSpots(); // Gọi phương thức để tải dữ liệu.
  }

  Future<void> _loadParkingSpots() async {
    ParkingSpotRepository _parkingSpotRepository = ParkingSpotRepository();
    final spots = await _parkingSpotRepository.getAllParkingSpots();
    setState(() {
      _parkingSpots = spots;
      _isLoading = false; // Dữ liệu đã được tải xong.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Spots List')),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Hiển thị khi đang tải dữ liệu.
      )
          : _parkingSpots.isNotEmpty
          ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
          child: Column(
            children: _parkingSpots.map((item) {
              return SizedBox(
                width: Get.width / 1,
                child: SpotItem(
                  data: item, userModel: widget.userModel,
                ),
              );
            }).toList(),
          ),
        ),
      )
          : const Center(
        child: Text('No Spots Available'), // Hiển thị khi không có dữ liệu.
      ),
    );
  }
}
