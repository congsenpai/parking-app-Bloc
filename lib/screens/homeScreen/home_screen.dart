import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/blocs/home/home_bloc.dart';
import 'package:project_smart_parking_app/blocs/home/home_event.dart';
import 'package:project_smart_parking_app/blocs/home/home_state.dart';
import 'package:project_smart_parking_app/screens/homeScreen/parking_sport_by_search.dart';

import '../../models/parking_spot_model.dart';
import '../../repositories/parking_spot_repository.dart';
import '../../widget/current_order.dart';
import '../../widget/footer_widget.dart';
import 'header_text.dart';
import 'nearby_parking_spots_widget.dart';
import 'order_recently_widget.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  // Tạo một TextEditingController để kiểm soát TextField
  TextEditingController _searchController = TextEditingController();

  ParkingSpotRepository _parkingSpotRepository = ParkingSpotRepository();
  List<ParkingSpotModel> parkingSpots = [];
  List<ParkingSpotModel> parkingSpotsBySearch = [];
  String currentText ='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeScreenBloc>().add(LoadParkingSpotsEvent());
    // Lắng nghe sự thay đổi của text trong _searchController
    _searchController.addListener(() {
      parkingSpotsBySearch = [];
      // Lấy giá trị hiện tại từ TextEditingController
      currentText = _searchController.text;
      context.read<HomeScreenBloc>().add(SearchParkingSpotsEvent(currentText));

      // In ra giá trị để kiểm tra
      print("Current search text: $currentText");

      // Thực hiện các hành động khác với currentText (ví dụ: gọi API tìm kiếm, cập nhật giao diện)
    });

  }

  bool isLogout(bool stopDefaultButtonEvent, RouteInfo info) {
    showDialog(context: context,
        builder:(context){
          return AlertDialog(
              title: Text('Confirm Exit'),
              content: Text('Do you want to exit this app?'),
              actions: [
                TextButton(
                  onPressed: () => print('Noooooooooo'),// Trả về "false" nếu người dùng chọn "No"
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {

                    SystemNavigator.pop(); // Thoát khỏi ứng dụng nếu người dùng chọn "Yes"
                    Navigator.of(context).pop(true); // Trả về "true" sau khi gọi SystemNavigator.pop()
                  },
                  child: Text('Yes'),
                ),

              ]);
        }

    ); // Do some stuff.
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<HomeScreenBloc, HomeScreenState>(
          builder: (context,state){

            if(state is HomeScreenLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            else if(state is HomeScreenLoaded){

              parkingSpots =state.parkingSpots;
              parkingSpotsBySearch = state.parkingSpotsBySearch;
              parkingSpots = state.parkingSpots;

            }

            return Scaffold(

              appBar: PreferredSize(
                preferredSize: Size.fromHeight(Get.width / 1.67),
                child: AppBar(
                  backgroundColor: Colors.black,
                  flexibleSpace: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: Get.width / 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Get.width / 40,
                                  ),
                                  SizedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: const CircleAvatar(
                                            minRadius: 20,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Get.width / 40,
                                        ),
                                        const Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Ha Gia",
                                              style: TextStyle(color: Color(0xFFFAF9F6)),
                                            ),
                                            Text(
                                              "Bao",
                                              style: TextStyle(
                                                  color: Color(0xFFFAF9F6), fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.width / 15,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Get Your\n", // Dòng đầu tiên
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(0.5), // Màu bóng
                                                offset: const Offset(2, 2), // Vị trí bóng
                                                blurRadius: 5.0, // Độ mờ
                                              ),
                                            ],
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Secure Park", // Dòng thứ hai
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.white.withOpacity(0.5), // Màu bóng
                                                offset: const Offset(2, 2), // Vị trí bóng
                                                blurRadius: 5.0, // Độ mờ
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              child: Image.asset(
                                "assets/images/AnhAppbar.png",
                                width: Get.width / 2.5,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width / 20, vertical: Get.width / 50),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by name or city area',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    color: Color.fromRGBO(230, 230, 230, 1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.width / 15),
                        // InProgressParking(location: 'null', placeName: 'null', url: 'null'),
                        Padding(padding: EdgeInsets.only(left: Get.width *0),
                            //
                            // widget hiển thị kết quả tìm kiếm
                            child: parkingSpotsBySearch.length == 0 || currentText == ''? Center(child: Center(
                              child: Text("Wellcome to my app",style: TextStyle(
                                fontSize: Get.width/15,
                                fontWeight: FontWeight.bold
                              ),
                              )
                            ))
                                : SafeArea(child: ParkingSportBySearch(parkingSpotsBySearch: parkingSpotsBySearch),)

                        ),
                        SizedBox(height: Get.width / 15),
                        HeaderText(textInSpan1: 'Nearby', textInSpan2: 'Parking Sport',),
                        SizedBox(height: Get.width / 15),
                        NearbyParkingSpotsWidget(parkingSpots: parkingSpots),
                        SizedBox(height: Get.width / 10),
                        HeaderText(textInSpan1: 'Recently', textInSpan2: 'Parking Sport'),
                        SizedBox(height: Get.width / 20),
                        OrderRecentlyWidget(),
                      ],
                    ),
                  ),
                ),
              ),



              bottomNavigationBar: SafeArea(
                child: footerWidget(),
              ),


            );
      },
          listener: (context,state){
            if(state is HomeScreenError){
              HomeScreenError("Failed to load & find data parking spots");
            }

          }
      );

  }
}
















