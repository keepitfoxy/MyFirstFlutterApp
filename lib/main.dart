import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/note_database.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/splashscreen/splash_screen.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart'; // Import ekranu logowania

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = NoteDatabase.instance;
  await db.initializeTestData(); // Dodaj dane testowe

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
      // Rejestrujemy trasy dla ekranu logowania, widoku głównego i splash screen
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), // Ekran startowy
        '/login': (context) => const LoginView(), // Ekran logowania
        '/home': (context) => const HomeView(), // Ekran główny
      },
    );
  }
}
