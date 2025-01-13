import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Dodano Firebase Core
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/splashscreen/splash_screen.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicjalizujemy Firebase
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // SplashScreen
        '/login': (context) => const LoginView(), // Ekran logowania
        '/home': (context) => const HomeView(), // Widok główny
      },
    );
  }
}
