import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/marketplace_viewmodel.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVM = ref.watch(authProvider);
    final user = authVM.user;

    if (user != null) {
      // Har login par Unique Key se 100% fresh state banegi
      return HomeScreen(key: ValueKey(user.uid));
    } else {
      return const LoginScreen();
    }
  }
}