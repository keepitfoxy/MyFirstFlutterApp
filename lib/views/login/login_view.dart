import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/login_widgets/login_form.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/login_widgets/login_footer.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea( // zabezpieczenie przed obszarami ekranu, które nie są bezpieczne
      child: Scaffold(
        body: SingleChildScrollView( // umożliwienie przewijania zawartości ekranu
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), // odstępy po bokach
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // wyśrodkowanie w poziomie
              children: [
                const SizedBox(height: 62), // odstęp od góry
                Image.asset(MyImages.logo, height: 129, width: 129), // wyświetlenie logo
                const SizedBox(height: 21), // odstęp między logo a tekstem
                _signInText, // tytuł ekranu
                const SizedBox(height: 46), // odstęp między tytułem a formularzem
                const LoginForm(), // formularz logowania
                const SizedBox(height: 150), // odstęp między formularzem a stopką
                const LoginFooter(), // stopka ekranu logowania
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _signInText {
    return Align( // wyrównanie tekstu
      alignment: Alignment.centerLeft, // wyrównanie tekstu do lewej
      child: Text(
        'Sign in', // tekst tytułu ekranu
        style: TextStyle(
          fontSize: 30, // wielkość tekstu
          fontWeight: FontWeight.w700, // pogrubienie tekstu
          color: MyColors.purpleColor, // kolor tekstu
        ),
      ),
    );
  }
}
