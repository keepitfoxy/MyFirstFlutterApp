import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/register/register_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/basic_text_form_field.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/confirmation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart'; // Import ekranu głównego

Future<void> login(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('userId', username); // Zapisujemy nazwę użytkownika jako identyfikator
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Dodanie zmiennej do zarządzania widocznością hasła

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 62),
                Image.asset(MyImages.logo, height: 129, width: 129),
                const SizedBox(height: 21),
                _signInText,

                const SizedBox(height: 46),

                // Email field
                BasicTextFormField(
                  hintText: 'Email or User Name',
                  iconWidget: Image.asset(MyImages.user, height: 24, width: 24),
                  controller: _usernameController, // Dodanie kontrolera
                ),

                const SizedBox(height: 40),

                // Password field
                BasicTextFormField(
                  hintText: 'Password',
                  iconWidget: Icon(
                    Icons.lock_outline,
                    color: MyColors.purpleColor,
                  ),
                  obscureText: _obscurePassword, // Zarządzanie widocznością hasła
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // Przełączanie widoczności
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20,
                      color: MyColors.purpleColor,
                    ),
                  ),
                  controller: _passwordController, // Dodanie kontrolera
                ),

                const SizedBox(height: 40),

                // Sign In button
                ConfirmationButton(
                  text: 'Sign in',
                  onPressed: () async {
                    final username = _usernameController.text.trim();
                    final password = _passwordController.text.trim();

                    if (username.isEmpty || password.isEmpty) {
                      // Proste sprawdzenie pól
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields'),
                        ),
                      );
                      return;
                    }

                    // Zapis użytkownika i przejście do HomeView
                    await login(username);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(), // Na ekran główny
                      ),
                    );
                  },
                ),

                const SizedBox(height: 150),

                // Sign Up link
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterView(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: MyColors.purpleColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _signInText {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Sign in',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: MyColors.purpleColor,
        ),
      ),
    );
  }
}
