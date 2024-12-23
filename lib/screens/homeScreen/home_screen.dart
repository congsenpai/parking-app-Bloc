import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:project_smart_parking_app/blocs/home/home_bloc.dart';
import 'package:project_smart_parking_app/blocs/home/home_event.dart';
import 'package:project_smart_parking_app/blocs/home/home_state.dart';
import 'package:project_smart_parking_app/screens/homeScreen/parking_sport_by_search.dart';
import 'package:provider/provider.dart';
import '../../models/parking_spot_model.dart';
import '../../models/user_model.dart';
import '../../repositories/parking_spot_repository.dart';
import '../../services/login_with_email.dart';
import '../../services/login_with_google.dart';
import '../../services/login_with_otp.dart';
import '../../widget/footer_widget.dart';
import '../loginScreen/login_screen.dart';
import 'header_text.dart';
import 'nearby_parking_spots_widget.dart';
import 'service_widget.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user; // Thêm biến này để lưu trữ thông tin user

  const HomeScreen(
      {super.key,
      required this.user}); // Sử dụng this.user để truy cập trong lớp State
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tạo một TextEditingController để kiểm soát TextField
  TextEditingController _searchController = TextEditingController();
  ParkingSpotRepository _parkingSpotRepository = ParkingSpotRepository();
  List<ParkingSpotModel> parkingSpots = [];
  List<ParkingSpotModel> parkingSpotsBySearch = [];
  List<ParkingSpotModel> RecentlyparkingSpots = [];
  String currentText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeScreenBloc>().add(LoadParkingSpotsEvent(widget.user.userID));
    // Lắng nghe sự thay đổi của text trong _searchController
    _searchController.addListener(() {
      parkingSpotsBySearch = [];
      // Lấy giá trị hiện tại từ TextEditingController
      currentText = _searchController.text;
      context.read<HomeScreenBloc>().add(SearchParkingSpotsEvent(currentText,widget.user.userID));
      // In ra giá trị để kiểm tra
      //print("Current search text: $currentText");

      // Thực hiện các hành động khác với currentText (ví dụ: gọi API tìm kiếm, cập nhật giao diện)
    });
    BackButtonInterceptor.add(isLogout);

    // Lắng nghe sự thay đổi từ TextField
    _searchController.addListener(() {
      if (kDebugMode) {
        print("Search text: ${_searchController.text}");
      }
      // Bạn có thể thực hiện bất kỳ hành động nào khi giá trị thay đổi
    });
  }

  @override
  void dispose() {
    // Hủy controller khi không còn cần thiết
    _searchController.dispose();
    super.dispose();
    BackButtonInterceptor.remove(isLogout);
  }

  bool isLogout(bool stopDefaultButtonEvent, RouteInfo info) {
    final LoginWithGoogle loginWithGoogle = LoginWithGoogle();
    final LoginWithEmail loginWithEmail = LoginWithEmail();
    final LoginWithOTP loginWithOTP = LoginWithOTP();

    // Get the current user authentication method from UserProvider or other management
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final String? currentAuthMethod = currentUser?.providerData.first
        .providerId; // For example: 'google.com', 'password', etc.

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Exit'),
          content: const Text('Do you want to exit this app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              // Close dialog if 'No' clicked
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Logout from the respective method only if user is logged in
                if (currentAuthMethod == 'google.com') {
                  await loginWithGoogle.signOut(); // Google logout
                } else if (currentAuthMethod == 'password') {
                  await loginWithEmail.signOut(); // Email logout
                } else if (currentAuthMethod == 'phone') {
                  await loginWithOTP.signOut(); // OTP logout
                }

                await Provider.of<UserProvider>(context, listen: false)
                    .logout(); // UserProvider logout
                Get.to(
                    const LoginScreen()); // Navigate to Login screen (or wherever you want to redirect)

                SystemNavigator.pop(); // Exit the app
                Navigator.of(context).pop(true); // Return "true" after exiting
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
      if (state is HomeScreenLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is HomeScreenLoaded) {
        parkingSpots = state.parkingSpots;
        parkingSpotsBySearch = state.parkingSpotsBySearch;
        RecentlyparkingSpots = state.parkingSpotsRecentlyOrder;
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.user.username,
                                        style: TextStyle(
                                            color: Color(0xFFFAF9F6),
                                            fontSize: 18),
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
                                          color: Colors.white.withOpacity(0.5),
                                          // Màu bóng
                                          offset: const Offset(2, 2),
                                          // Vị trí bóng
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
                                          color: Colors.white.withOpacity(0.5),
                                          // Màu bóng
                                          offset: const Offset(2, 2),
                                          // Vị trí bóng
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
              color: const Color.fromRGBO(230, 230, 230, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.width / 15),
                  // InProgressParking(location: 'null', placeName: 'null', url: 'null'),
                  Padding(
                      padding: EdgeInsets.only(left: Get.width * 0),
                      //
                      // widget hiển thị kết quả tìm kiếm
                      child: parkingSpotsBySearch.length == 0 ||
                              currentText == ''
                          ? Center(
                              child: Center(
                                  child: Text(
                              "Wellcome to my app",
                              style: TextStyle(
                                  fontSize: Get.width / 15,
                                  fontWeight: FontWeight.bold),
                            )))
                          : SafeArea(
                              child: ParkingSportBySearch(
                                  parkingSpotsBySearch: parkingSpotsBySearch),
                            )),
                  SizedBox(height: Get.width / 15),
                  const HeaderText(
                    textInSpan1: 'Nearby',
                    textInSpan2: 'Parking Sport',
                  ),
                  SizedBox(height: Get.width / 15),
                  NearbyParkingSpotsWidget(parkingSpots: parkingSpots, userID: widget.user.userID, userName: widget.user.username,),
                  SizedBox(height: Get.width / 10),
                  const HeaderText(
                      textInSpan1: 'Recently', textInSpan2: 'Parking Sport'),
                  SizedBox(height: Get.width / 20),
                  NearbyParkingSpotsWidget(parkingSpots: RecentlyparkingSpots, userID: widget.user.userID, userName: widget.user.username,),
                  SizedBox(height: Get.width / 10),
                  const HeaderText(
                      textInSpan1: 'My', textInSpan2: 'Services'),
                  SizedBox(height: Get.width / 20),
                  ServiceWidget(userID: widget.user.userID),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: footerWidget(userID: widget.user.userID, userName: widget.user.username,),
        ),
      );
    }, listener: (context, state) {
      if (state is HomeScreenError) {
        HomeScreenError("Failed to load & find data parking spots");
      }
    });
  }
}
