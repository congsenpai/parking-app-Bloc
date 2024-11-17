// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/services/login_with_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:project_smart_parking_app/services/login_with_email.dart';
import 'package:project_smart_parking_app/services/login_with_google.dart';
import 'package:project_smart_parking_app/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _loginWithEmail;
  final LoginWithGoogle _loginWithGoogle;
  final LoginWithOTP _loginWithOTP;

  AuthBloc(this._loginWithEmail, this._loginWithGoogle, this._loginWithOTP)
      : super(AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithPhoneNumberEvent>(_onLoginWithOTP);
  }

  void _onLoginWithOTP(LoginWithPhoneNumberEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserModel? user =
          await _loginWithOTP.signInWithOTP(event.phoneNumber, event.otp);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  void _onLoginWithEmail(
      LoginWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserModel? user = await _loginWithEmail.signInWithEmailPassword(
          event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login failed. Please check your credentials.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }

  void _onLoginWithGoogle(
      LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      UserModel? user = await _loginWithGoogle.signInWithGoogle();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('Login failed. Please try again.'));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}'));
    }
  }
}
