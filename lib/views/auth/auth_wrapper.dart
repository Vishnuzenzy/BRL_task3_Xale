import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import '../home/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthenticationProvider>();

    // Agar user logged in hai toh Home par redirect hoga, warna Login screen[cite: 1, 2]
    if (auth.user != null) {
      return const HomeScreen(); 
    }

    return const LoginScreen();
  }
}