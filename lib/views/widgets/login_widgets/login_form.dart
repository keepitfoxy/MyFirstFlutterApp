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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final userId = await NoteDatabase.instance.authenticateUser(username, password);

    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BasicTextFormField(
          hintText: 'Email or User Name',
          iconWidget: Icon(Icons.person, color: MyColors.purpleColor),
          controller: _usernameController,
        ),
        const SizedBox(height: 40),
        BasicTextFormField(
          hintText: 'Password',
          iconWidget: Icon(Icons.lock, color: MyColors.purpleColor),
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
          onPressed: _handleLogin,
        ),
      ],
    );
  }
}
