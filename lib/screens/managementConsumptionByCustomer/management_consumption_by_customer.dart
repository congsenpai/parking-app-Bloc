import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:project_smart_parking_app/repositories/transaction_repository.dart';

import 'ExpensesByUp_Down.dart';
import 'LineChartSample.dart';
class ManagementConsumptionByCustomer extends StatefulWidget {
  final String userID;
  const ManagementConsumptionByCustomer({super.key, required this.userID});
  @override
  State<ManagementConsumptionByCustomer> createState() => _ManagementConsumptionByCustomerState();
}
class _ManagementConsumptionByCustomerState extends State<ManagementConsumptionByCustomer> {

  late int _SelectedYear = 2024;
  late int _selectedMonth = 0;
  late int Balance = 0;
  late int Expencse = 0;
  late List<FlSpot> _up;
  late List<FlSpot> _down;
  late List<int> availableYears; // Danh sách các năm hiển thị trong dropdown
  late List<int> availableMonths;

  @override
  void initState() {
    super.initState();
    _up = [];
    _down = [];
    availableYears = [2020, 2021, 2022, 2023, 2024]; // Có thể lấy động từ backend
    availableMonths = [0,1,2,3,4,5,6,7,8,9,10,11,12];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sử dụng post frame callback để đảm bảo _loadData được gọi sau khi layout hoàn thành
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();  // Tải lại dữ liệu sau khi layout hoàn tất
    });
  }

  // Hàm tải dữ liệu
  Future<void> _loadData() async {
    TransactionRepository transactionRepository = TransactionRepository();

    try {
      Balance = 0; // Đặt lại giá trị
      Expencse = 0; // Đặt lại giá trị
      List<ConsumptionByMonth> consumpsByMonth = await transactionRepository.getlistTransactionOfCustomerbyUserID(widget.userID);
      List<ConsumptionByDay> consumpsByDay = await transactionRepository.getlistTransactionOfCustomerByDay(widget.userID);
           // Lọc dữ liệu theo năm đã chọn
      List<FlSpot> upFlSpots = [];
      List<FlSpot> downFlSpots = [];
      if(_selectedMonth == 0){
        for (var consum in consumpsByMonth) {
          if (consum.year == _SelectedYear) {
            upFlSpots.addAll(consum.Up_flspots); // Thêm FlSpots Up
            downFlSpots.addAll(consum.Down_flspots); // Thêm FlSpots Down
            for (var spot in consum.Up_flspots) {
              Balance += spot.y.toInt(); // Cộng giá trị `y` cho Balance
            }
            for (var spot in consum.Down_flspots) {
              Expencse += spot.y.toInt(); // Cộng giá trị `y` cho Expencse
            }
          }
        }
      }
      else{
        for (var consum in consumpsByDay) {
          if (consum.year == _SelectedYear && consum.month == _selectedMonth) {
            upFlSpots.addAll(consum.Up_flspots); // Thêm FlSpots Up
            downFlSpots.addAll(consum.Down_flspots); // Thêm FlSpots Down

            for (var spot in consum.Up_flspots) {
              Balance += spot.y.toInt(); // Cộng giá trị `y` cho Balance
            }
            for (var spot in consum.Down_flspots) {
              Expencse += spot.y.toInt(); // Cộng giá trị `y` cho Expencse
            }
          }
        }
      }
      setState(() {
        _up = upFlSpots;
        _down = downFlSpots;
        _up.sort((a, b) => a.x.compareTo(b.x));
        // Sắp xếp _down theo thứ tự tăng dần của x
        _down.sort((a, b) => a.x.compareTo(b.x));

        print(_up);
        print(_down); // Cập nhật danh sách _down đã được sắp xếp// Cập nhật dữ liệu FlSpots Down

      });
    } catch (e) {
      print("Lỗi khi tải dữ liệu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Consumption Management", style: TextStyle(
            fontSize: Get.width/20,
            fontWeight: FontWeight.bold
          ), ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: SingleChildScrollView(  // Bao bọc với SingleChildScrollView
            child: Column(
              children: [
                // Dropdown chọn năm
                Container(
                  padding: EdgeInsets.all(Get.width/20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // chọn tháng
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black,
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3), // Màu bóng, điều chỉnh độ mờ ở đây
                              offset: Offset(2, 2), // Vị trí bóng (x, y)
                              blurRadius: 5, // Độ mờ của bóng
                              spreadRadius: 2, // Độ lan rộng của bóng
                            ),
                          ],

                        ),
                        child: SizedBox(
                          width:  Get.width/5,
                          height: Get.width/15,
                          child: DropdownButton<int>(
                            value: _selectedMonth,
                            icon: const Icon(Icons.arrow_downward),
                            isExpanded: true, // Mở rộng toàn bộ chiều rộng
                            alignment: Alignment.centerRight,
                            onChanged: (int? newValue) {
                              setState(() {
                                _selectedMonth = newValue!;
                              });
                              print("Available : $availableMonths");
                              print("Selected : $_selectedMonth");
                              _loadData(); // Tải lại dữ liệu khi thay đổi năm
                            },
                            items: availableMonths.map<DropdownMenuItem<int>>((int month) {
                              return DropdownMenuItem<int>(
                                value: month,
                                child: Center(child: Text('${month.toString()}')),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(width: Get.width/30,),
                      // chọn năm
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3), // Màu bóng, điều chỉnh độ mờ ở đây
                              offset: Offset(2, 2), // Vị trí bóng (x, y)
                              blurRadius: 5, // Độ mờ của bóng
                              spreadRadius: 2, // Độ lan rộng của bóng
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: Get.width/4, // Chiều rộng mong muốn
                          height: Get.width/15, // Chiều cao mong muốn
                          child: DropdownButton<int>(
                            value: _SelectedYear,
                            icon: const Icon(Icons.arrow_downward),
                            isExpanded: true, // Cho phép dropdown mở rộng hết chiều rộng của widget cha// Mở rộng toàn bộ chiều rộng
                            alignment: Alignment.centerRight,
                            onChanged: (int? newValue) {
                              setState(() {
                                _SelectedYear = newValue!;
                              });
                              print("Available years: $availableYears");
                              print("Selected year: $_SelectedYear");
                              _loadData(); // Tải lại dữ liệu khi thay đổi năm
                            },
                            items: availableYears.map<DropdownMenuItem<int>>((int year) {
                              return DropdownMenuItem<int>(
                                value: year,
                                child: Center(child: Text(year.toString())),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Biểu đồ line chart hiển thị dữ liệu
                _up.isEmpty && _down.isEmpty
                    ?
                const Center(child: Center(child: Text('Do not any transactions at this time'),))
                    : _selectedMonth == 0 ?
                      Container(

                        margin: EdgeInsets.all(Get.width/70),
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3), // Màu bóng, điều chỉnh độ mờ ở đây
                              offset: Offset(2, 2), // Vị trí bóng (x, y)
                              blurRadius: 5, // Độ mờ của bóng
                              spreadRadius: 2, // Độ lan rộng của bóng
                            ),
                          ],
                        ),
                        // Chắc chắn rằng biểu đồ chiếm một không gian cụ thể
                        width: Get.width/1.1, // Đảm bảo biểu đồ có chiều rộng đầy đủ
                        height: Get.width,  // Cung cấp chiều cao cố định cho biểu đồ
                        child: LineChartSample(
                          up: _up,
                          down: _down,
                          X_AxisTitles: 'Month',
                          Y_AxisTitles: 'Expenses',
                          maxX: 12,
                          maxY: 10000000,
                        ),
                      ) :
                      Container(

                        margin: EdgeInsets.all(Get.width/70),
                        decoration: BoxDecoration(

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3), // Màu bóng, điều chỉnh độ mờ ở đây
                              offset: Offset(2, 2), // Vị trí bóng (x, y)
                              blurRadius: 5, // Độ mờ của bóng
                              spreadRadius: 2, // Độ lan rộng của bóng
                            ),
                          ],
                        ),// Chắc chắn rằng biểu đồ chiếm một không gian cụ thể
                          width: Get.width/1.1, // Đảm bảo biểu đồ có chiều rộng đầy đủ
                        height: Get.width, // Cung cấp chiều cao cố định cho biểu đồ
                        child: LineChartSample(
                          up: _up,
                          down: _down,
                          X_AxisTitles: 'Day',
                          Y_AxisTitles: 'Expenses',
                          maxX: 31,
                          maxY: 10000000,
                        ),
                      )

                ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExpensesByUp_Down(Blance: Balance.toDouble(), Title: 'Balance', color: Colors.green,),
                      ExpensesByUp_Down(Blance: Expencse.toDouble(), Title: 'Expencse', color: Colors.redAccent,)
                    ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

