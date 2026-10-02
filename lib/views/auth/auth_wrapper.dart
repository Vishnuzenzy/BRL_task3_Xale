import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import '../home/home_screen.dart';


class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    
    final auth = ref.watch(authProvider);

    if (auth.user != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}