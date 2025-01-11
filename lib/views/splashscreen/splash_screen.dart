import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _navigateBasedOnLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Naviguj do odpowiedniego ekranu
    if (isLoggedIn) {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    } else {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      _navigateBasedOnLoginStatus(context);
    });

    return Scaffold(
      backgroundColor: MyColors.whiteColor, // Tło białe
      body: Stack(
        children: [
          // tło
          _buildBackground(),
          Center(
            child: Image.asset(
              'assets/images/logo_bigger.png',
              width: 250,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -150,
          left: -70,
          child: _buildCircle(MyColors.lilacColor, 300),
        ),
        Positioned(
          top: -250,
          right: -130,
          child: _buildCircle(MyColors.purpleColor, 350),
        ),
        Positioned(
          bottom: -300,
          left: -50,
          child: _buildCircle(MyColors.purpleColor, 400),
        ),
        Positioned(
          bottom: -150,
          right: -150,
          child: _buildCircle(MyColors.lilacColor, 300),
        ),
      ],
    );
  }

  Widget _buildCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(1.0),
        shape: BoxShape.circle,
      ),
    );
  }
}
