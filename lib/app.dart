import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/client/dashboard/screens/client_dashboard_screen.dart';
import 'features/public/home/screens/home_screen.dart';
import 'core/services/auth_service.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authService = ref.read(authServiceProvider);
    final isLoggedIn = await authService.isLoggedIn();
    
    if (!mounted) return;
    
    if (isLoggedIn) {
      final user = await authService.getCurrentUser();
      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ClientDashboardScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}