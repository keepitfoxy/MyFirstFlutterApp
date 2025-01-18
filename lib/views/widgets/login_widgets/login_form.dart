import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/data/note_database.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/basic_text_form_field.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/confirmation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lisiecka_aplikacje_mobilne/views/home/home_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController(); // kontroler dla pola nazwy użytkownika
  final TextEditingController _passwordController = TextEditingController(); // kontroler dla pola hasła
  bool _obscurePassword = true; // stan ukrycia hasła

  @override
  void dispose() {
    _usernameController.dispose(); // zwolnienie zasobów kontrolera nazwy użytkownika
    _passwordController.dispose(); // zwolnienie zasobów kontrolera hasła
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // obsługa logowania
    final username = _usernameController.text; // pobranie nazwy użytkownika
    final password = _passwordController.text; // pobranie hasła

    final userId = await NoteDatabase.instance.authenticateUser(username, password); // uwierzytelnienie użytkownika

    if (userId != null) {
      // zapisanie danych logowania w SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()), // nawigacja do ekranu głównego
      );
    } else {
      // wyświetlenie komunikatu o błędzie logowania
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed. Please try again.'), // komunikat o błędnym logowaniu
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BasicTextFormField(
          hintText: 'Email or User Name', // podpowiedź w polu tekstowym
          iconWidget: Icon(Icons.person, color: MyColors.purpleColor), // ikona obok pola tekstowego
          controller: _usernameController, // przypisanie kontrolera do pola tekstowego
        ),
        const SizedBox(height: 40), // odstęp między polami
        BasicTextFormField(
          hintText: 'Password', // podpowiedź w polu tekstowym
          iconWidget: Icon(Icons.lock, color: MyColors.purpleColor), // ikona obok pola tekstowego
          obscureText: _obscurePassword, // ustawienie ukrycia hasła
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword; // przełączanie widoczności hasła
              });
            },
            child: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility, // ikona widoczności hasła
              color: MyColors.purpleColor,
            ),
          ),
          controller: _passwordController, // przypisanie kontrolera do pola tekstowego
        ),
        const SizedBox(height: 40), // odstęp między polami a przyciskiem
        ConfirmationButton(
          text: 'Sign in', // tekst na przycisku
          onPressed: _handleLogin, // akcja po kliknięciu przycisku
        ),
      ],
    );
  }
}
