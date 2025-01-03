// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/user/user_event.dart';
import 'package:project_smart_parking_app/blocs/user/user_state.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/repositories/user_reponsitory.dart';



class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(): super(UserInitial()) {
    on<ChangeProfileEvent>(_ChangeProfile);
    on<InitstateEvent>(_InitState);
  }
  Future<UserModel?> _InitState(InitstateEvent event,
      Emitter<UserState> emit) async{
    try{
      UserRepository userRepository = UserRepository();
      UserModel? userModel = await userRepository.getUserByID(event.userId);
      emit(UserLoaded(userModel!));
    }
    catch(e){
      emit(UserError('Loading user_bloc page false'));
    }
    return null;
  }
  Future<void> _ChangeProfile(ChangeProfileEvent event,
      Emitter< UserState> emit) async {
    // emit(HomeScreenLoading());
    try {

      UserRepository userRepository =  UserRepository();
      await userRepository.updateUserByID(
          event.userID,
          event.userName,
          event.email,
          event.phone,
          event.userImg,
          event.country,
          event.userAddress,
          event.vehicle);
      UserModel? userModel = await userRepository.getUserByID(event.userID);
      emit(UserLoaded(userModel!));
    }
    catch (e) {
      // ignore: avoid_print
      print('update ${e}');
      emit(UserError('update in user_bloc page false'));
    }
  }

}