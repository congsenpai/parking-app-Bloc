import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_bloc.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_event.dart';
import 'package:project_smart_parking_app/blocs/booking/booking_state.dart';






import '../../Language/language.dart';
import '../../widget/Starwidget.dart';



class ParkingBookingDetailScreen extends StatefulWidget {



  const ParkingBookingDetailScreen({super.key});

  @override
  State<ParkingBookingDetailScreen> createState() => _ParkingBookingDetailScreenState();
}

class _ParkingBookingDetailScreenState extends State<ParkingBookingDetailScreen> {
  LanguageSelector languageSelector = LanguageSelector();
  final String language ='vi';
  final double PriceOf1hourCar = 20000;
  final double PriceOf1hourMoto = 20000;
  double Total = 0;
  double Insaurence = 0.01;
  TimeOfDay? TotalTime ;
  final List<String> VehicalLisence = ['30A-12345', '29B-67890', '51C-54321'];
  late String SelecteVehicalLisence = '';

  final StringURl = "assets/images/Location1_HVNH/HvnhMain.png";
  DateTime selectedDateStart = DateTime.now();
  DateTime selectedDateEnd = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 1,minute: 1);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingScreenBloc,BookingScreenState>(
        builder: (context,state){
          if(state is BookingScreenLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(state is BookingScreenLoaded){
            selectedDateStart =state.selectedDateStart!;
            selectedDateEnd = state.selectedDateEnd!;
            startTime = state.startTime!;
            endTime = state.endTime!;
            TotalTime = state.TotalTime;
            Total = state.Total!;
          }
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'Check Out',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(Get.width/20),
                    // column tổng
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // thanh 1 ( ảnh và sao )
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8), // Không có viền bo tròn
                              child: Image.asset(
                                StringURl,
                                height: Get.width / 4,
                                width: Get.width / 3,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: Get.width/10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Học Viện Ngân Hàng ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width/25)
                                ),
                                Text('3k/hr',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width/25)),
                                const StarWidget(startNumber: 4,evaluateNumber: 12000,),
                              ],
                            ),
                          ],
                        ),
                        // tổng thời gian
                        Padding(
                          padding:  EdgeInsets.only(top:Get.width/20),
                          child: Column(
                            children: [
                              Text(
                                "Chọn ngày và thời gian",
                                style: TextStyle(
                                  fontSize: Get.width / 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: Get.width / 25),
                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1.5),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  // ngày bắt đầu
                                  TableRow(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2024),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null) {
                                              selectedDateStart = pickedDate;
                                              context.read<BookingScreenBloc>().add(
                                                  SelectAndCheckTimeEvent(
                                                      selectedDateStart,
                                                      selectedDateEnd,
                                                      startTime,
                                                      endTime,
                                                      PriceOf1hourCar,
                                                      0.1)
                                              );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white24), // Màu nền
                                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black), // Màu chữ
                                          // Padding
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>( // Định hình nút
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15), // Góc bo tròn
                                            ),
                                          ),
                                        ),
                                        child: const Text("Chọn Ngày Bắt Đầu"),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                           '${selectedDateStart.toLocal()}'.split(' ')[0] ,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // thời gian bắt đầu
                                  TableRow(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (pickedTime != null) {
                                              startTime = pickedTime;
                                              context.read<BookingScreenBloc>().add(
                                                  SelectAndCheckTimeEvent(
                                                      selectedDateStart,
                                                      selectedDateEnd,
                                                      startTime,
                                                      endTime,
                                                      PriceOf1hourCar,
                                                      0.1)
                                              );
                                          }
                                        },
                                        style: ButtonStyle(

                                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white24), // Màu nền
                                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black), // Màu chữ
                                          // Padding
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>( // Định hình nút
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15), // Góc bo tròn
                                            ),
                                          ),

                                        ),
                                        child: const Text("Chọn Thời Gian Bắt Đầu"),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          startTime.format(context),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // ngày kết thúc
                                  TableRow(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2101),
                                          );
                                          if (pickedDate != null ) {
                                            selectedDateEnd = pickedDate;
                                            context.read<BookingScreenBloc>().add(
                                                SelectAndCheckTimeEvent(
                                                    selectedDateStart,
                                                    selectedDateEnd,
                                                    startTime,
                                                    endTime,
                                                    PriceOf1hourCar,
                                                    0.1)
                                            );
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white24), // Màu nền
                                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black), // Màu chữ
                                          // Padding
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>( // Định hình nút
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15), // Góc bo tròn
                                            ),
                                          ),
                                        ),
                                        child: const Text("Chọn Ngày Kết Thúc",style: TextStyle(
                                            color: Colors.black
                                        ),),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          (selectedDateStart.isBefore(selectedDateEnd) == true
                                              || selectedDateStart.isAtSameMomentAs(selectedDateStart) == true
                                          )
                                              ? '${selectedDateEnd.toLocal()}'.split(' ')[0] : 'Chưa chọn',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // thời gian kết thúc
                                  TableRow(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          TimeOfDay? pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (pickedTime != null) {
                                              endTime = pickedTime;
                                              context.read<BookingScreenBloc>().add(
                                                  SelectAndCheckTimeEvent(
                                                      selectedDateStart,
                                                      selectedDateEnd,
                                                      startTime,
                                                      endTime,
                                                      PriceOf1hourCar,
                                                      0.1)
                                              );
                                          }
                                        },
                                        style: ButtonStyle(

                                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white24), // Màu nền
                                          foregroundColor: WidgetStateProperty.all<Color>(Colors.black), // Màu chữ
                                          // Padding
                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>( // Định hình nút
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15), // Góc bo tròn
                                            ),
                                          ),

                                        ),
                                        child: const Text("Chọn Thời Gian Kết Thúc",style: TextStyle(
                                            color: Colors.black
                                        ),
                                        ),

                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          endTime.format(context),

                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // chọn biển số xe
                        Padding(
                            padding:  EdgeInsets.only(top:Get.width/15),
                          child: Column(
                            children: [
                              Text("CHỌN XE", style: TextStyle(
                                fontSize: Get.width/25,
                                fontWeight: FontWeight.bold,

                              )),
                              SizedBox(height: Get.width/15,),

                              Table(
                                // border: TableBorder.all(
                                //   color: Colors.black, // Màu viền
                                //   width: 2.0, // Độ dày của viền
                                // ),
                                columnWidths: const{
                                  0: FlexColumnWidth(1.5),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                          alignment: Alignment.center,
                                          child: Text('Chọn biển số xe',style: TextStyle(fontSize: Get.width/23))),

                                      Container(
                                          alignment: Alignment.center,
                                          child: Text('Biển số',style: TextStyle(fontSize: Get.width/23))
                                      )
                                    ]
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: DropdownButton<String>(
                                          value: SelecteVehicalLisence.isEmpty ? null : SelecteVehicalLisence,
                                          items: VehicalLisence.map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,style: TextStyle(fontSize: Get.width/23)),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              SelecteVehicalLisence = newValue!;
                                            });
                                          },
                                        ),
                                      ),

                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          SelecteVehicalLisence.isEmpty
                                              ? 'Chưa chọn'
                                              : '$SelecteVehicalLisence',
                                          style: TextStyle(fontSize: Get.width/23),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                        ),
                        // tổng bill
                        Padding(padding: EdgeInsets.all(Get.width/25),
                          child: Column(
                            children: [
                            Text("TOTAL BILL", style: TextStyle(
                            fontSize: Get.width/25,
                            fontWeight: FontWeight.bold,)
                            ),
                              SizedBox(height: Get.width/15,),

                              Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(), // Cột đầu tiên sẽ tự động căn trái
                                  1: FlexColumnWidth(), // Cột thứ hai tự động căn phải
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text('Price Per House'),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.all(8.0),
                                        child:  Text("$PriceOf1hourCar VND"),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8.0),

                                        child: Text(
                                            'Total Time'
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.all(8.0),

                                        child: Text(
                                          TotalTime != null
                                              && Total != 0
                                              ? '${TotalTime!.hour} giờ'  // Hiển thị chỉ giờ
                                              : 'Hãy chọn lại giá trị \n nhập vào hợp lý',
                                          style: TextStyle(fontSize: Total == 0 ? 14: 16, color: Total ==0 ? Colors.red: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text('Insaurence'),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text('1%'),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Text('Total'),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('$Total VND'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // thanh toán
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8.0),

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue,
                            ),
                            child: TextButton(onPressed: (){},
                                child: Text('Thanh toán',
                                  style: TextStyle(
                                      fontSize: Get.width/20,
                                      color: Colors.white
                                  ),
                                )
                            )
                        ),
                      ],
                    ),

                  ),
                ),
              )
          );
        },
        listener: (context,state){
          if(state is BookingScreenError){
            BookingScreenError('Dont Load data');
          }
        }
        );
  }
}
