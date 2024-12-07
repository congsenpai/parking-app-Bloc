import 'auth_event.dart';
import 'auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/services/login_with_otp.dart';
import 'package:project_smart_parking_app/services/login_with_email.dart';
import 'package:project_smart_parking_app/services/login_with_google.dart';
// auth_bloc.dart

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _loginWithEmail;
  final LoginWithGoogle _loginWithGoogle;
  final LoginWithOTP _loginWithOTP;
  bool isRemember = false;

  AuthBloc(this._loginWithEmail, this._loginWithGoogle, this._loginWithOTP)
      : super(AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithPhoneNumberEvent>(_onLoginWithOTP);
    on<ToggleRememberMeEvent>(_onToggleRememberMe);
  }

  // Toggle the "Remember Me" value
  void _onToggleRememberMe(ToggleRememberMeEvent event, Emitter<AuthState> emit) {
    isRemember = event.isRemember;
    emit(AuthInitial().copyWith(isRemember: isRemember));  // Update isRemember when toggled
  }

  void _onLoginWithOTP(LoginWithPhoneNumberEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading( isRemember: isRemember));
    try {
      UserModel? user = await _loginWithOTP.signInWithOTP(event.phoneNumber, event.otp, isRemember: isRemember);

      if (user != null) {
        emit(AuthAuthenticated(user, isRemember: isRemember));
      } else {
        emit(AuthError('Login failed. Please check your credentials.', isRemember: isRemember));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}', isRemember: isRemember));
    }
  }

  void _onLoginWithEmail(LoginWithEmailEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading(isRemember: isRemember));
    try {
      UserModel? user = await _loginWithEmail.signInWithEmailPassword(event.email, event.password, isRemember: isRemember);

      if (user != null) {
        emit(AuthAuthenticated(user, isRemember: isRemember));
      } else {
        emit(AuthError('Login failed. Please check your credentials.', isRemember: isRemember));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}', isRemember: isRemember));
    }
  }

  void _onLoginWithGoogle(LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading(isRemember: isRemember));
    try {
      UserModel? user = await _loginWithGoogle.signInWithGoogle(isRemember: isRemember);

      if (user != null) {
        emit(AuthAuthenticated(user, isRemember: isRemember));
      } else {
        emit(AuthError('Login failed. Please try again.', isRemember: isRemember));
      }
    } catch (e) {
      emit(AuthError('An error occurred: ${e.toString()}', isRemember: isRemember));
    }
  }

}



