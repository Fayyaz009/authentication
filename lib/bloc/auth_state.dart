part of 'auth_bloc.dart';

enum AuthAction {
  signIn,
  signUp,
  resetPassword,
  google,
  anonymous,
  signOut,
  none,
}

enum AuthMode { signIn, signUp }

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String userId;
  final String userName;
  Authenticated(this.userId, this.userName);
  @override
  List<Object> get props => [userId];
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class PasswordResetSent extends AuthState {}

class AccountCreated extends AuthState {
  final String message;
  AccountCreated(this.message);
  @override
  List<Object> get props => [message];
}

class AuthLoading extends AuthState {
  final AuthAction action;
  AuthLoading({this.action = AuthAction.none});
  @override
  List<Object> get props => [action];
}

class AuthModeToggled extends AuthState {
  final AuthMode mode;
  AuthModeToggled({this.mode = AuthMode.signIn});
  @override
  List<Object> get props => [mode];
}
