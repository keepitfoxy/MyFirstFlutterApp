import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // ustawienie wyrównania u dołu
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20), // odstęp od dolnej krawędzi
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // wyrównanie wiersza na środku
          children: [
            const Text('Already have an account?'), // wyświetlenie tekstu
            TextButton(
              // przycisk przechodzący do widoku logowania
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()), // nawigacja do ekranu logowania
                );
              },
              child: Text(
                'Sign In', // tekst na przycisku
                style: TextStyle(color: MyColors.purpleColor), // styl tekstu
              ),
            ),
          ],
        ),
      ),
    );
  }
}
