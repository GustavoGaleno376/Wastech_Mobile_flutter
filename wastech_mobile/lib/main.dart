import 'package:flutter/material.dart';
import 'dashboard/app_theme.dart';
import 'screens/Login Screen/login_screen.dart';
import 'calculos_irrigacao/eto.dart';
import 'calculos_irrigacao/etc.dart';
import 'calculos_irrigacao/ko.dart';

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
      home: const LoginScreen(),
      routes: {
        '/eto': (_) => const ETOPage(),
        '/etc': (_) => const ETCCPage(),
        '/kc': (_) => KoPage(),
      },
    );
  }
}
