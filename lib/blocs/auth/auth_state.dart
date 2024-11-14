// auth_state.dart
import '../../models/user_model.dart';

abstract class AuthState {
  final bool isRemember;

  AuthState({required this.isRemember});

  // Add copyWith method in the base class
  AuthState copyWith({bool? isRemember});
}

class AuthInitial extends AuthState {
  AuthInitial({bool isRemember = false}) : super(isRemember: isRemember);

  @override
  AuthInitial copyWith({bool? isRemember}) {
    return AuthInitial(isRemember: isRemember ?? this.isRemember);
  }
}

class AuthLoading extends AuthState {
  AuthLoading({required bool isRemember}) : super(isRemember: isRemember);

  @override
  AuthLoading copyWith({bool? isRemember}) {
    return AuthLoading(isRemember: isRemember ?? this.isRemember);
  }
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated(this.user, {required bool isRemember}) : super(isRemember: isRemember);

  @override
  AuthAuthenticated copyWith({bool? isRemember}) {
    return AuthAuthenticated(user, isRemember: isRemember ?? this.isRemember);
  }
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message, {required bool isRemember}) : super(isRemember: isRemember);

  @override
  AuthError copyWith({bool? isRemember}) {
    return AuthError(message, isRemember: isRemember ?? this.isRemember);
  }
}
