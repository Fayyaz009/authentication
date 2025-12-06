import 'package:auth_practice/reuseable_widgets/auth_divider.dart';
import 'package:auth_practice/reuseable_widgets/custom_button.dart';
import 'package:auth_practice/reuseable_widgets/appformfield.dart';
import 'package:auth_practice/reuseable_widgets/validation_utils.dart';
import 'package:auth_practice/screens/forget_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/auth_bloc.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userController = TextEditingController();
  bool isLogin = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomeScreen(state.userId, state.userName),
              ),
            );
          }
          if (state is AccountCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.teal,
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                ),
              ),
            );
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                shape: BeveledRectangleBorder(),
                content: Text(
                  textAlign: TextAlign.justify,
                  state.errorMessage,
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                backgroundColor: Colors.red[700],
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLogin ? 'Welcome Back' : 'Create an Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isLogin
                                    ? "Sign in to continue"
                                    : 'Sign up to get started',
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),
                              const SizedBox(height: 32),

                              // Username field only in Sign Up
                              if (!isLogin)
                                AppFormField(
                                  controller: userController,
                                  key: const Key('usernameField'),
                                  labelText: const Text('Username'),
                                  prefixIcon: const Icon(
                                    Icons.verified_user_outlined,
                                  ),
                                  validator: (value) =>
                                      ValidationUtils.userNameValidation(value),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  hintText: 'Enter username',
                                ),

                              if (!isLogin) const SizedBox(height: 20),

                              AppFormField(
                                controller: emailController,
                                key: const Key('emailField'),
                                labelText: const Text('Email'),
                                prefixIcon: const Icon(Icons.email_outlined),
                                validator: (value) =>
                                    ValidationUtils.emailValidation(value),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                hintText: 'abc@gmail.com',
                              ),
                              const SizedBox(height: 20),

                              AppFormField(
                                controller: passwordController,
                                key: const Key('passwordField'),
                                labelText: const Text('Password'),
                                prefixIcon: const Icon(Icons.password_outlined),
                                validator: (value) =>
                                    ValidationUtils.passwordValidation(value),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                hintText: 'Abc123@',
                                obscureText: false,
                              ),
                              // Forgot Password - only in login
                              if (isLogin)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 5),
                                    Text(
                                      'Forgot Password? ',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: state is AuthLoading
                                          ? null
                                          : () {
                                              Navigator.push(
                                                // pushReplacement → push
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const ForgetScreen(),
                                                ),
                                              );
                                              emailController.clear();
                                              passwordController.clear();
                                              _formKey.currentState!.reset();
                                            },
                                      child: state is AuthLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Reset',
                                              style: GoogleFonts.poppins(
                                                color: Colors.deepPurpleAccent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 20),

                              // Sign In / Sign Up Button
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final bool loading = state is AuthLoading;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      buttonName: loading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              isLogin ? 'Sign in' : 'Sign Up',
                                            ),
                                      onPressed: loading
                                          ? null
                                          : isLogin
                                          ? () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                {
                                                  context.read<AuthBloc>().add(
                                                    SignInRequested(
                                                      emailController.text
                                                          .trim(),
                                                      passwordController.text
                                                          .trim(),
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                {
                                                  context.read<AuthBloc>().add(
                                                    SignUpRequested(
                                                      userController.text
                                                          .trim(),
                                                      emailController.text
                                                          .trim(),
                                                      passwordController.text
                                                          .trim(),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 10),
                              const AuthDivider(),
                              const SizedBox(height: 10),

                              // Google Sign In
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final bool loading =
                                      state is AuthLoading &&
                                      state.action == AuthAction.google;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      buttonName: loading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text('Sign in with Google'),
                                      onPressed: state is AuthLoading
                                          ? null
                                          : () {
                                              context.read<AuthBloc>().add(
                                                GoogleSignInRequested(),
                                              );
                                            },
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 15),

                              // Anonymous Sign In
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final bool loading =
                                      state is AuthLoading &&
                                      state.action == AuthAction.anonymous;
                                  return SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      buttonName: loading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text('Sign in Anonymously'),
                                      onPressed: state is AuthLoading
                                          ? null
                                          : () {
                                              context.read<AuthBloc>().add(
                                                AnonymousSignInRequested(),
                                              );
                                            },
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              // Toggle Sign In / Sign Up
                              BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isLogin
                                            ? " Don't have an account? "
                                            : " Already have an account? ",
                                        style: GoogleFonts.poppins(
                                          color: const Color.fromARGB(
                                            221,
                                            14,
                                            14,
                                            14,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : () {
                                                setState(() {
                                                  isLogin = !isLogin;
                                                  _formKey.currentState!
                                                      .reset();
                                                  emailController.clear();
                                                  passwordController.clear();
                                                });
                                                if (isLogin) {
                                                  userController.clear();
                                                  emailController.clear();
                                                  passwordController.clear();
                                                }
                                              },
                                        child: Text(
                                          isLogin ? "Sign Up" : "Sign In",
                                          style: GoogleFonts.poppins(
                                            color: Colors.deepPurpleAccent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
