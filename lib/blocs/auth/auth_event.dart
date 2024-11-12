// auth_event.dart
abstract class AuthEvent {}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  LoginWithEmailEvent(this.email, this.password);
}

class LoginWithGoogleEvent extends AuthEvent {}

class LoginWithPhoneNumberEvent extends AuthEvent {
  final String phoneNumber; // Thêm số điện thoại
  final String otp;
  LoginWithPhoneNumberEvent(this.phoneNumber, this.otp);
}
