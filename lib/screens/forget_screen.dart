import 'package:auth_practice/bloc/auth_bloc.dart';
import 'package:auth_practice/reuseable_widgets/custom_button.dart';
import 'package:auth_practice/reuseable_widgets/texformfield.dart';
import 'package:auth_practice/reuseable_widgets/validation_utils.dart';
import 'package:auth_practice/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listenWhen: (previous, current) => previous != current,
            listener: (context, state) {
              // show snackbars / navigation based on bloc states
              if (state is PasswordResetSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Reset link sent to your email!"),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              final sending = state is AuthLoading;

              return Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Enter your email",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 05),
                          Center(
                            child: Text(
                              "We will send a reset password link to your email.",
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          AppFormField(
                            controller: emailController,
                            labelText: Text('Email'),
                            hintText: 'Email',

                            prefixIcon: Icon(Icons.email),
                            validator: (value) =>
                                ValidationUtils.emailValidation(value),
                          ),

                          const SizedBox(height: 20),

                          // Reset Button
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              // show spinner when sending, else text
                              buttonName: sending
                                  ? SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text('Send Reset Link'),
                              backgroundColor: Colors.deepPurple,
                              textColor: Colors.white,
                              onPressed: sending
                                  ? null
                                  : () {
                                      // VALIDATION: dispatch only when form is VALID
                                      if (_formKey.currentState!.validate()) {
                                        // send event to bloc
                                        context.read<AuthBloc>().add(
                                          ResetPasswordRequested(
                                            emailController.text.trim(),
                                          ),
                                        );
                                      }
                                    },
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Already have account?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Remember password? ",
                                style: GoogleFonts.poppins(color: Colors.grey),
                              ),

                              TextButton(
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
