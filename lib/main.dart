import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lisiecka_aplikacje_mobilne/data/note_database.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/splashscreen/splash_screen.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // zapewnienie prawidłowej inicjalizacji przed uruchomieniem aplikacji

  // inicjalizowanie Firebase
  await Firebase.initializeApp(); // konfiguracja Firebase w aplikacji
  await testFirebaseConnection(); // test połączenia z Firebase
  await NoteDatabase.instance.initializeTestData(); // inicjalizacja danych testowych w bazie danych SQLite

  runApp(const MyApp()); // uruchomienie aplikacji
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // ukrycie bannera trybu debugowania
      title: 'My First Flutter App', // tytuł aplikacji
      theme: ThemeData(
        primarySwatch: Colors.purple, // główny kolor aplikacji
      ),
      initialRoute: '/', // początkowa trasa aplikacji
      routes: {
        '/': (context) => const SplashScreen(), // ekran startowy (splash screen)
        '/login': (context) => const LoginView(), // ekran logowania
        '/home': (context) => const HomeView(), // główny ekran aplikacji
      },
    );
  }
}

// testowanie połączenia z Firebase
Future<void> testFirebaseConnection() async {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('test'); // odniesienie do węzła "test" w Firebase
  try {
    await dbRef.set({'message': 'Test successful!'}); // zapis testowej wiadomości w bazie danych Firebase
    print('Firebase connection works!'); // informacja o poprawnym połączeniu
  } catch (e) {
    print('Error connecting to Firebase: $e'); // informacja o błędzie podczas połączenia
  }
}
