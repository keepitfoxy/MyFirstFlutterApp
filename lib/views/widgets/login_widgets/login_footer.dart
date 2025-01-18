import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/register/register_view.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter, // wyrównanie komponentu na dole ekranu
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20), // odstęp od dołu
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // wyśrodkowanie tekstu i przycisku
          children: [
            const Text("Don't have an account?"), // tekst informacyjny
            TextButton(
              onPressed: () {
                Navigator.push( // przejście do ekranu rejestracji
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterView()),
                );
              },
              child: Text(
                'Sign Up', // tekst przycisku
                style: TextStyle(color: MyColors.purpleColor), // kolor tekstu przycisku
              ),
            ),
          ],
        ),
      ),
    );
  }
}
