import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_smart_parking_app/blocs/auth/auth_bloc.dart';
import 'package:project_smart_parking_app/blocs/auth/auth_event.dart';
import 'package:project_smart_parking_app/blocs/auth/auth_state.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/services/login_with_email.dart';
import 'package:project_smart_parking_app/services/login_with_google.dart';
import 'package:project_smart_parking_app/services/login_with_otp.dart';
import 'package:project_smart_parking_app/services/remember_me_service.dart';

// Mock các service
class MockLoginWithEmail extends Mock implements LoginWithEmail {}
class MockLoginWithGoogle extends Mock implements LoginWithGoogle {}
class MockLoginWithOTP extends Mock implements LoginWithOTP {}
class MockRememberMeService extends Mock implements RememberMeService {}

void main() {
  late AuthBloc authBloc;
  late MockLoginWithEmail mockLoginWithEmail;
  late MockLoginWithGoogle mockLoginWithGoogle;
  late MockLoginWithOTP mockLoginWithOTP;
  late MockRememberMeService mockRememberMeService;

  // Thiết lập trước mỗi test
  setUp(() {
    mockLoginWithEmail = MockLoginWithEmail();
    mockLoginWithGoogle = MockLoginWithGoogle();
    mockLoginWithOTP = MockLoginWithOTP();
    mockRememberMeService = MockRememberMeService();

    authBloc = AuthBloc(
      mockLoginWithEmail,
      mockLoginWithGoogle,
      mockLoginWithOTP,
      mockRememberMeService,
    );
  });

  // Dọn dẹp sau mỗi test
  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    // Kiểm tra trạng thái khởi tạo
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    // Test ToggleRememberMeEvent
    blocTest<AuthBloc, AuthState>(
      'emits AuthInitial with isRemember toggled when ToggleRememberMeEvent is added',
      build: () => authBloc,
      act: (bloc) => bloc.add(ToggleRememberMeEvent(
        isRemember: true,
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [isA<AuthInitial>()],
    );

    // Test LoginWithEmailEvent thành công
    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading and then AuthAuthenticated when LoginWithEmailEvent is successful',
      build: () => authBloc,
      setUp: () {
        when(() => mockLoginWithEmail.signInWithEmailPassword(any(), any()))
            .thenAnswer((_) async => UserModel(
          vehicle: '',
          userID: 'user12345',
          username: 'john_doe',
          email: 'john.doe@example.com',
          phone: '+1234567890',
          userImg: 'https://example.com/image.jpg',
          userDeviceToken: 'deviceToken12345',
          country: 'USA',
          userAddress: '123 Main St, Springfield',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now().subtract(Duration(days: 5)),
          city: 'New York',
        ));
      },
      act: (bloc) => bloc.add(LoginWithEmailEvent('test@example.com', 'password123')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    // Test LoginWithEmailEvent thất bại
    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading and then AuthError when LoginWithEmailEvent fails',
      build: () => authBloc,
      setUp: () {
        when(() => mockLoginWithEmail.signInWithEmailPassword(any(), any()))
            .thenThrow(Exception('Login failed'));
      },
      act: (bloc) => bloc.add(LoginWithEmailEvent('wrong@example.com', 'wrongpassword')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    // Test LoginWithGoogleEvent thành công
    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading and then AuthAuthenticated when LoginWithGoogleEvent is successful',
      build: () => authBloc,
      setUp: () {
        when(() => mockLoginWithGoogle.signInWithGoogle())
            .thenAnswer((_) async => UserModel(
          vehicle: '',
          userID: 'user12345',
          username: 'john_doe',
          email: 'john.doe@example.com',
          phone: '+1234567890',
          userImg: 'https://example.com/image.jpg',
          userDeviceToken: 'deviceToken12345',
          country: 'USA',
          userAddress: '123 Main St, Springfield',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now().subtract(Duration(days: 5)),
          city: 'New York',
        ));
      },
      act: (bloc) => bloc.add(LoginWithGoogleEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    // Test LoginWithPhoneNumberEvent thành công
    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading and then AuthAuthenticated when LoginWithPhoneNumberEvent is successful',
      build: () => authBloc,
      setUp: () {
        when(() => mockLoginWithOTP.signInWithOTP(any(), any()))
            .thenAnswer((_) async => UserModel(
          vehicle: '',
          userID: 'user12345',
          username: 'john_doe',
          email: 'john.doe@example.com',
          phone: '+1234567890',
          userImg: 'https://example.com/image.jpg',
          userDeviceToken: 'deviceToken12345',
          country: 'USA',
          userAddress: '123 Main St, Springfield',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now().subtract(Duration(days: 5)),
          city: 'New York',
        ));
      },
      act: (bloc) => bloc.add(LoginWithPhoneNumberEvent('123456789', '123456')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    // Test LoginWithPhoneNumberEvent thất bại
    blocTest<AuthBloc, AuthState>(
      'emits AuthLoading and then AuthError when LoginWithPhoneNumberEvent fails',
      build: () => authBloc,
      setUp: () {
        when(() => mockLoginWithOTP.signInWithOTP(any(), any()))
            .thenThrow(Exception('Login failed'));
      },
      act: (bloc) => bloc.add(LoginWithPhoneNumberEvent('123456789', 'wrongotp')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );
  });
}
