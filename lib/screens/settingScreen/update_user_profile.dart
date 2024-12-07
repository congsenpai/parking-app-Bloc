
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project_smart_parking_app/blocs/user/user_bloc.dart';
import 'package:project_smart_parking_app/blocs/user/user_event.dart';
import 'package:project_smart_parking_app/blocs/user/user_state.dart';
import 'package:project_smart_parking_app/widget/footer_widget.dart';

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({super.key});

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Center(child: Text('My Profile'),),
      ),
      body: BlocConsumer<UserBloc,UserState>(
          builder:(context,state){
            if(state is InitstateEvent){



            }
            else if(state is ChangeProfileEvent){

            }
            else if(state is UserLoading){
              return const Center(child: CircularProgressIndicator(),);
            }
            return SafeArea(child: Container(
              padding: EdgeInsets.all(Get.width / 20),
              margin: EdgeInsets.only(top: Get.width/20, bottom: Get.width/20),
              child: Column(
                children: [

                  SizedBox(height: Get.width/50),
                  // user name
                  TextField(
                    controller: _userName,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: Get.width/50),
                  // email
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                      hintText: ''
                    ),
                  ),
                  SizedBox(height: Get.width/50),
                  // phone
                  TextField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: Get.width/50),
                  // user Image
                  TextField(
                    controller: _userImg,
                    decoration: const InputDecoration(
                      labelText: "User Image",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: Get.width/50),
                  // country
                  TextField(
                    controller: _country,
                    decoration: const InputDecoration(
                      labelText: "country",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  // user address
                  TextField(
                    controller: _userAddress,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "userAddress",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: Get.width/50),
                  ElevatedButton(
                      onPressed: () {
                        // Xử lý đăng nhập
                      },
                      child: Center(child: Text("Update"),)
                  ),
                ]
              ),
            ),
            );

          },
          listener: (context,state){
            if (state is UserError){
              UserError('Loading Data was false');
            }
          }),
      bottomNavigationBar: footerWidget(),


    );
  }
}
