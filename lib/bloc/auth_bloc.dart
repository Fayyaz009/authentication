import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _services;
  AuthBloc()
    : _services = AuthRepository(FirebaseAuth.instance, GoogleSignIn.instance),
      super(AuthInitial()) {
    on<SignInRequested>(signInRequested);
    on<SignUpRequested>(signUpRequested);
    on<GoogleSignInRequested>(googleSignInRequested);
    on<SignOutRequested>(signOutRequested);
    on<CheckAuthStatus>(checkAuthStatus);
    on<AnonymousSignInRequested>(anonymousSignInRequested);
    on<ToggleAuthModeRequested>(toggleAuthModeRequested);
    on<ResetPasswordRequested>(resetPasswordRequested);
  }

  Future<void> signInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(action: AuthAction.signIn));
    try {
      User? user = await _services.signIn(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user.uid, user.displayName ?? 'No Display Name'));
      } else {
        emit(
          AuthError(
            errorMessage:
                'Please Check your inbox or spam folder to verify your email First',
          ),
        );
      }
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> signUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(action: AuthAction.signUp));
    try {
      String message = await _services.signUpRequested(
        event.userName,
        event.email,
        event.password,
      );

      emit(AccountCreated(message));
    } on FirebaseAuthException catch (e) {
      // YE SABSE ZAROORI HAI – emit karna mat bhoolna!
      String message = e.message ?? 'Sign Up Failed';

      if (e.code == 'weak-password') {
        message = 'Password should be at least 6 characters';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already registered!';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }

      emit(AuthError(errorMessage: message));
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  Future<void> googleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthLoading(action: AuthAction.google),
    ); //enum jo bnaya hai us se le rhy hai takeh baki buttons pr na show ho loading
    try {
      await Future.delayed(Duration(seconds: 3));
      User? user = await _services.googleSignIn();
      emit(Authenticated(user!.uid, user.displayName ?? 'No Display Name'));
    } catch (error) {
      emit(AuthError(errorMessage: error.toString()));
    }
  }

  FutureOr<void> signOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(action: AuthAction.signOut));
    try {
      await _services.signOut();
      emit(UnAuthenticated());
    } catch (error) {
      emit(AuthError(errorMessage: error.toString()));
    }
  }

  FutureOr<void> checkAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      User? userCredential = await _services.checkAuthStatus();
      if (userCredential != null) {
        emit(
          Authenticated(
            userCredential.uid,
            userCredential.displayName ?? 'No Display Name',
          ),
        );
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      AuthError(errorMessage: e.toString());
    }
  }

  FutureOr<void> anonymousSignInRequested(
    AnonymousSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(action: AuthAction.anonymous));
    try {
      User? user = await _services.anonymousSignIn();
      emit(Authenticated(user!.uid, user.displayName ?? 'No Display Name'));
    } catch (e) {
      emit(AuthError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> toggleAuthModeRequested(
    ToggleAuthModeRequested event,
    Emitter<AuthState> emit,
  ) {
    final currentState =
        state; //state ko variable mn store kerna zrori hai wrna dart smjhta hai keh authstate initial hai

    AuthMode newMode;

    if (currentState is AuthModeToggled) {
      newMode = currentState.mode == AuthMode.signIn
          ? AuthMode.signUp
          : AuthMode.signIn;
    } else {
      // Pehli baar ya Initial state se → Sign Up pe jao
      newMode = AuthMode.signUp;
    }

    emit(AuthModeToggled(mode: newMode));
  }

  FutureOr<void> resetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading(action: AuthAction.resetPassword));
    try {
      await Future.delayed(Duration(seconds: 2));
      await _services.resetPasswordRequested(event.email);
      emit(PasswordResetSent());
    } catch (e) {
      AuthError(errorMessage: e.toString());
    }
  }
}
