import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const HomeScreen(this.userId, this.userName, {super.key}); // const bana diya

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // YE 3 LINES HI SAB KUCH FIX KAR DETI HAIN
        if (state is UnAuthenticated) {
          if (!mounted) return; // Critical line
          Navigator.of(context).pushReplacement(
            // Best way
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final bool isSigningOut =
                    state is AuthLoading && state.action == AuthAction.signOut;

                return TextButton(
                  onPressed: isSigningOut
                      ? null
                      : () => context.read<AuthBloc>().add(SignOutRequested()),
                  child: isSigningOut
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.black),
                        ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome!', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Text(
                  'Display Name: ${widget.userName}',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'User ID: ${widget.userId}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
