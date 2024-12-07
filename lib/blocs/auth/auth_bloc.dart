import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../../services/login_with_email.dart';
import '../../services/login_with_google.dart';
import '../../services/login_with_otp.dart';
import '../../services/remember_me_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail _loginWithEmail;
  final LoginWithGoogle _loginWithGoogle;
  final LoginWithOTP _loginWithOTP;
  final RememberMeService _rememberMeService; // Add service

  bool isRemember = false;

  AuthBloc(this._loginWithEmail, this._loginWithGoogle, this._loginWithOTP,
      this._rememberMeService)
      : super(AuthInitial()) {
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LoginWithPhoneNumberEvent>(_onLoginWithOTP);
    on<ToggleRememberMeEvent>(_onToggleRememberMe);
  }

  void _onToggleRememberMe(ToggleRememberMeEvent event,
      Emitter<AuthState> emit) async {
    isRemember = event.isRemember;
    if (!isRemember) {
      // Clear saved credentials when "Remember Me" is unchecked
      await _rememberMeService.clearCredentials();
    }
    emit(AuthInitial().copyWith(isRemember: isRemember));
  }

  void _onLoginWithEmail(LoginWithEmailEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading(isRemember: isRemember));
    try {
      UserModel? user = await _loginWithEmail.signInWithEmailPassword(
          event.email, event.password);

      if (user != null) {
        if (isRemember) {
          // Save email and password if "Remember Me" is checked
          await _rememberMeService.saveCredentials(event.email, event.password);
        }
        emit(AuthAuthenticated(user, isRemember: isRemember));
      } else {
        emit(AuthError('Login failed. Please check your credentials.',
            isRemember: isRemember));
      }
    } catch (e) {
      emit(AuthError(
          'An error occurred: ${e.toString()}', isRemember: isRemember));
    }
  }

  void _onLoginWithGoogle(LoginWithGoogleEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading(isRemember: isRemember));
    try {
      UserModel? user = await _loginWithGoogle.signInWithGoogle();

      if (user != null) {
        if (isRemember) {
          // Save user ID (or relevant data) for "Remember Me"
          await _rememberMeService.saveCredentials(user.email ?? '',
              ''); // Google login usually doesn't include password
        }
        emit(AuthAuthenticated(user, isRemember: isRemember));
      } else {
        emit(AuthError(
            'Login failed. Please try again.', isRemember: isRemember));
      }
    } catch (e) {
      emit(AuthError(
          'An error occurred: ${e.toString()}', isRemember: isRemember));
    }
  }

  void _onLoginWithOTP(LoginWithPhoneNumberEvent event,
      Emitter<AuthState> emit) async {
    emit(AuthLoading(isRemember: isRemember));
    try {
      UserModel? user = await _loginWithOTP.signInWithOTP(
          event.phoneNumber, event.otp);

      if (user != null) {
        if (isRemember) {
          // Save phone number for "Remember Me"
          await _rememberMeService.saveCredentials(
              event.phoneNumber, ''); // OTP usually doesn't include password
        }
        emit(AuthAuthenticated(user, isRemember: isRemember));
      } else {
        emit(AuthError('Login failed. Please check your credentials.',
            isRemember: isRemember));
      }
    } catch (e) {
      emit(AuthError(
          'An error occurred: ${e.toString()}', isRemember: isRemember));
    }
  }


}