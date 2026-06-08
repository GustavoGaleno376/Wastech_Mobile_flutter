import 'package:flutter/material.dart';

// Imports dos seus arquivos locais
import 'calculos_irrigacao/eto.dart'; 
import 'calculos_irrigacao/etc.dart'; 
import 'calculos_irrigacao/ko.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wastech Mobile',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22C55E)), 
        useMaterial3: true,
      ),
      
      // Define a rota inicial diretamente na raiz, que aponta para o ETOPage
      initialRoute: '/', 
      
      routes: {
        '/': (context) => const ETOPage(),      // Abre o ETo direto do start
        '/etcc': (context) => const ETCCPage(), // Rota mapeada para a tela etc.dart
        '/kc': (context) => KoPage(),           // Rota mapeada para a tela ko.dart
      },
    );
  }
}