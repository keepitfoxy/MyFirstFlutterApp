import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnLoginStatus(); // rozpoczęcie nawigacji na podstawie statusu logowania
  }

  Future<void> _navigateBasedOnLoginStatus() async {
    final prefs = await SharedPreferences.getInstance(); // pobranie preferencji użytkownika
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // sprawdzenie, czy użytkownik jest zalogowany

    // nawigacja do odpowiedniego ekranu po opóźnieniu
    Future.delayed(const Duration(seconds: 2), () {
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()), // przejście do widoku głównego
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()), // przejście do widoku logowania
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor, // ustawienie białego tła
      body: Stack( // użycie stosu do nakładania elementów
        children: [
          _buildBackground(), // dodanie tła
          Center(
            child: Image.asset(
              'assets/images/logo_bigger.png', // logo aplikacji
              width: 250,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack( // stos do umieszczania kół w tle
      children: [
        Positioned( // pozycjonowanie pierwszego koła
          top: -150,
          left: -70,
          child: _buildCircle(MyColors.lilacColor, 300), // lilacowe koło
        ),
        Positioned( // pozycjonowanie drugiego koła
          top: -250,
          right: -130,
          child: _buildCircle(MyColors.purpleColor, 350), // fioletowe koło
        ),
        Positioned( // pozycjonowanie trzeciego koła
          bottom: -300,
          left: -50,
          child: _buildCircle(MyColors.purpleColor, 400), // fioletowe koło
        ),
        Positioned( // pozycjonowanie czwartego koła
          bottom: -150,
          right: -150,
          child: _buildCircle(MyColors.lilacColor, 300), // lilacowe koło
        ),
      ],
    );
  }

  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size, // szerokość koła
      height: size, // wysokość koła
      decoration: BoxDecoration(
        color: color.withOpacity(1.0), // kolor z pełną widocznością
        shape: BoxShape.circle, // kształt koła
      ),
    );
  }
}
