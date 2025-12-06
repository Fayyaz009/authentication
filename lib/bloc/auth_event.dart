part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String userName;
  final String email;
  final String password;
  SignUpRequested(this.userName, this.email, this.password);
}

class GoogleSignInRequested extends AuthEvent {}

class AnonymousSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class ToggleAuthModeRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  ResetPasswordRequested(this.email);
}
