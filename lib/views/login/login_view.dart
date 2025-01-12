import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/note_database.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/register/register_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/basic_text_form_field.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/confirmation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';

Future<void> login(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', true);
  await prefs.setString('userId', userId);
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
                BasicTextFormField(
                  hintText: 'Email or User Name',
                  iconWidget: Image.asset(MyImages.user, height: 24, width: 24),
                  controller: _usernameController,
                ),
                const SizedBox(height: 40),
                BasicTextFormField(
                  hintText: 'Password',
                  iconWidget: Icon(Icons.lock_outline, color: MyColors.purpleColor),
                  obscureText: _obscurePassword,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: MyColors.purpleColor,
                    ),
                  ),
                  controller: _passwordController,
                ),
                const SizedBox(height: 40),
                ConfirmationButton(
                  text: 'Sign in',
                  onPressed: () async {
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    // Uwierzytelnianie użytkownika
                    final userId = await NoteDatabase.instance.authenticateUser(username, password);

                    if (userId != null) { // Jeśli użytkownik został uwierzytelniony
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setInt('userId', userId); // Zapisz ID użytkownika jako int
                      await prefs.setBool('isLoggedIn', true); // Oznacz użytkownika jako zalogowanego

                      // Przejdź do HomeView
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                      );
                    } else {
                      // Obsługa błędnego logowania
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Authentication failed. Please try again.'),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 150),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterView()),
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
