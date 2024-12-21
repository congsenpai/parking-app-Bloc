
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/blocs/user/user_bloc.dart';
import 'package:project_smart_parking_app/blocs/user/user_event.dart';
import 'package:project_smart_parking_app/blocs/user/user_state.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/widget/footer_widget.dart';

class UpdateUserProfile extends StatefulWidget {
  final String UserID;
  const UpdateUserProfile({super.key, required this.UserID});

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  late TextEditingController _userName;
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _userImg;
  late TextEditingController _country;
  late TextEditingController _userAddress;

  late TextEditingController _userVehicleLicense;

  late UserModel userModel = UserModel(
    vehicle: '', // Sử dụng cú pháp đúng của Map
    userID: '',
    username: '',
    email: '',
    phone: '',
    userImg: '',
    userDeviceToken: '',
    country: '',
    userAddress: '',
    isAdmin: true,
    isActive: true,
    createdOn: Timestamp.now().toString(), // Chuyển đổi sang chuỗi nếu cần
    city: '',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Khởi tạo TextEditingController
    _userName = TextEditingController();
    _email = TextEditingController();
    _phone = TextEditingController();
    _userImg = TextEditingController();
    _country = TextEditingController();
    _userAddress = TextEditingController();
    _userVehicleLicense = TextEditingController();


    context.read<UserBloc>().add(InitstateEvent(widget.UserID));
    print(widget.UserID);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Profile')),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            userModel = state.userModel;
            print(userModel);
            // Gán dữ liệu cho TextEditingController
            _userName.text = userModel.username;
            _email.text = userModel.email;
            _phone.text = userModel.phone;
            _userImg.text = userModel.userImg;
            _country.text = userModel.country;
            _userAddress.text = userModel.userAddress;
            _userVehicleLicense.text = userModel.vehicle;

          } else if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(Get.width / 20),
              margin: EdgeInsets.only(top: Get.width / 20, bottom: Get.width / 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _userName,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _userImg,
                      decoration: InputDecoration(
                        labelText: "User Image",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _country,
                      decoration: InputDecoration(
                        labelText: "Country",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _userAddress,
                      decoration: InputDecoration(
                        labelText: "Address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Get.width / 50),
                    TextField(
                      controller: _userVehicleLicense,
                      decoration: InputDecoration(
                        labelText: "Vehicles",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: Get.width / 50),
                    ElevatedButton(
                      onPressed: () {


                        context.read<UserBloc>().add(ChangeProfileEvent(
                          widget.UserID,
                          _userName.text,
                          _email.text,
                          _phone.text,
                          _userImg.text,
                          _country.text,
                          _userAddress.text,
                          _userVehicleLicense.text,
                        ));
                      },
                      child: Center(
                        child: Text("Update"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is UserError) {
            UserError('Loading Data was false');
          }
        },
      ),
      bottomNavigationBar: footerWidget(userID: widget.UserID, userName: _userName.text,),
    );
  }

}


