import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/blocs/register/register_event.dart';
import 'package:project_smart_parking_app/blocs/register/register_state.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/services/login_with_otp.dart';
import 'package:project_smart_parking_app/services/login_with_email.dart';
import 'package:project_smart_parking_app/services/login_with_google.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _registerWithEmail;
  final LoginWithGoogle _registerWithGoogle;
  final LoginWithOTP _registerWithOTP;

  AuthBloc(this._registerWithEmail, this._registerWithGoogle, this._registerWithOTP)
      : super(AuthInitial()) {
    on<RegisterWithEmailEvent>(_onRegister);
    on<RegisterWithGoogleEvent>(_onRegister);
    on<RegisterWithPhoneNumberEvent>(_onRegister);
  }

  // General method to handle register logic
  Future<void> _onRegister(AuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      UserModel? user;

      if (event is RegisterWithEmailEvent) {
        user = await _registerWithEmail.signUpWithEmailPassword(event.email, event.password);
      } else if (event is RegisterWithGoogleEvent) {
        user = await _registerWithGoogle.signUpWithGoogle();
      } else if (event is RegisterWithPhoneNumberEvent) {
        user = await _registerWithOTP.signInWithOTP(event.phoneNumber, event.otp);
      }

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Registration failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }
}
