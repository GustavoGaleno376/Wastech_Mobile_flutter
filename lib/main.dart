import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dashboard/app_theme.dart';
import 'screens/login/login_screen.dart';
import 'calculos_irrigacao/eto.dart';
import 'calculos_irrigacao/etc.dart';
import 'calculos_irrigacao/kc.dart';
import 'dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      // O StreamBuilder escuta o Firebase e decide qual tela mostrar
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const DashboardScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        '/eto': (_) => const ETOPage(),
        '/etc': (_) => const ETCCPage(),
        '/kc': (_) => KcPage(),
      },
    );
  }
}
