// auth_state.dart
import '../../models/user_model.dart';

abstract class AuthState {
  final bool isRemember;

  AuthState({required this.isRemember});

  // Add copyWith method in the base class
  AuthState copyWith({bool? isRemember});
}

class AuthInitial extends AuthState {
  AuthInitial({super.isRemember = false});

  @override
  AuthInitial copyWith({bool? isRemember}) {
    return AuthInitial(isRemember: isRemember ?? this.isRemember);
  }
}

class AuthLoading extends AuthState {
  AuthLoading({required super.isRemember});

  @override
  AuthLoading copyWith({bool? isRemember}) {
    return AuthLoading(isRemember: isRemember ?? this.isRemember);
  }
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user, {required super.isRemember});

  @override
  AuthAuthenticated copyWith({bool? isRemember}) {
    return AuthAuthenticated(user, isRemember: isRemember ?? this.isRemember);
  }
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message, {required super.isRemember});

  @override
  AuthError copyWith({bool? isRemember}) {
    return AuthError(message, isRemember: isRemember ?? this.isRemember);
  }
}
