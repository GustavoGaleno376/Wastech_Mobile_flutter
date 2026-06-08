import 'package:flutter/material.dart';
import 'screens/Login Screen/login_screen.dart';
import 'dashboard/app_theme.dart';
import 'dashboard/dashboard_screen.dart';

void main() {
  runApp(const WastechApp());
}

class WastechApp extends StatelessWidget {
  const WastechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wastech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DashboardScreen(),
    );
  }
}
