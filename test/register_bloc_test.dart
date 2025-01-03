import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project_smart_parking_app/blocs/register/register_bloc.dart';
import 'package:project_smart_parking_app/blocs/register/register_event.dart';
import 'package:project_smart_parking_app/blocs/register/register_state.dart';
import 'package:project_smart_parking_app/models/user_model.dart';
import 'package:project_smart_parking_app/services/login_with_email.dart';
import 'package:project_smart_parking_app/services/login_with_google.dart';
import 'package:project_smart_parking_app/services/login_with_otp.dart';

// Mock classes
class MockLoginWithEmail extends Mock implements LoginWithEmail {}

class MockLoginWithGoogle extends Mock implements LoginWithGoogle {}

class MockLoginWithOTP extends Mock implements LoginWithOTP {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockLoginWithEmail mockLoginWithEmail;
    late MockLoginWithGoogle mockLoginWithGoogle;
    late MockLoginWithOTP mockLoginWithOTP;

    setUp(() {
      mockLoginWithEmail = MockLoginWithEmail();
      mockLoginWithGoogle = MockLoginWithGoogle();
      mockLoginWithOTP = MockLoginWithOTP();
      authBloc = AuthBloc(mockLoginWithEmail, mockLoginWithGoogle, mockLoginWithOTP);
    });

    tearDown(() {
      authBloc.close();
    });

    final UserModel mockUser = UserModel(
        vehicle: '',
        userID: '',
        username: '',
        email: '',
        phone: '',
        userImg: '',
        userDeviceToken: '',
        country: '',
        userAddress: '',
        isAdmin: true, isActive: true,
        createdOn: Timestamp.now(),
        city: '');

    // Test initial state
    test('initial state is AuthInitial', () {
      () => [
        isA<AuthInitial>()
      ];
    });

    // Test RegisterWithEmailEvent success
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when RegisterWithEmailEvent succeeds',
      build: () {
        when(() => mockLoginWithEmail.signUpWithEmailPassword(any(), any()))
            .thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterWithEmailEvent('test@example.com', 'password123', 'password123')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()

      ],
    );

    // Test RegisterWithEmailEvent failure
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when RegisterWithEmailEvent fails',
      build: () {
        when(() => mockLoginWithEmail.signUpWithEmailPassword(any(), any()))
            .thenThrow(Exception('Email registration failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterWithEmailEvent('test@example.com', 'password123', 'password123')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()

      ],
    );

    // Test RegisterWithGoogleEvent success
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when RegisterWithGoogleEvent succeeds',
      build: () {
        when(() => mockLoginWithGoogle.signInWithGoogle())
            .thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterWithGoogleEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()

      ],
    );

    // Test RegisterWithGoogleEvent failure
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when RegisterWithGoogleEvent fails',
      build: () {
        when(() => mockLoginWithGoogle.signInWithGoogle())
            .thenThrow(Exception('Google registration failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterWithGoogleEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()

      ],
    );

    // Test RegisterWithPhoneNumberEvent success
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when RegisterWithPhoneNumberEvent succeeds',
      build: () {
        when(() => mockLoginWithOTP.signInWithOTP(any(), any()))
            .thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterWithPhoneNumberEvent('1234567890', '123456')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>()

      ],
    );

    // Test RegisterWithPhoneNumberEvent failure
    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when RegisterWithPhoneNumberEvent fails',
      build: () {
        when(() => mockLoginWithOTP.signInWithOTP(any(), any()))
            .thenThrow(Exception('Phone registration failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterWithPhoneNumberEvent('1234567890', '123456')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>()

      ],
    );
  });
}
