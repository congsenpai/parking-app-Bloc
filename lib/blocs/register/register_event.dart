abstract class AuthEvent {}

class RegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String retypePassword;
  RegisterWithEmailEvent(this.email, this.password, this.retypePassword);
}

class RegisterWithGoogleEvent extends AuthEvent {}

class RegisterWithPhoneNumberEvent extends AuthEvent {
  final String phoneNumber; // Thêm số điện thoại
  final String otp;
  RegisterWithPhoneNumberEvent(this.phoneNumber, this.otp);
}
