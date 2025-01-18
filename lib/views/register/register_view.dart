import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/register_widgets/register_background.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/register_widgets/register_footer.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/register_widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea( // zabezpieczenie przed obszarami ekranu, które nie są bezpieczne
      child: Scaffold(
        body: Stack( // umożliwienie nakładania na siebie elementów
          children: [
            const RegisterBackground(), // tło ekranu rejestracji
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // odstępy po bokach
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // wyrównanie elementów do lewej
                children: [
                  const SizedBox(height: 59), // odstęp od góry
                  GestureDetector( // umożliwienie powrotu do poprzedniego ekranu
                    onTap: () => Navigator.pop(context), // nawigacja wstecz
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, color: MyColors.purpleColor, size: 15), // ikona powrotu
                        Text(
                          'Back', // tekst przycisku powrotu
                          style: TextStyle(
                            fontSize: 12, // wielkość tekstu
                            fontWeight: FontWeight.w500, // grubość czcionki
                            color: MyColors.purpleColor, // kolor tekstu
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 101), // odstęp między przyciskiem powrotu a tytułem
                  Text(
                    'Sign Up', // tytuł ekranu
                    style: TextStyle(
                      fontSize: 30, // wielkość tekstu
                      fontWeight: FontWeight.w700, // grubość czcionki
                      color: MyColors.purpleColor, // kolor tekstu
                    ),
                  ),
                  const SizedBox(height: 46), // odstęp między tytułem a formularzem
                  const RegisterForm(), // formularz rejestracji
                  const Spacer(), // wypełnienie wolnej przestrzeni
                  const RegisterFooter(), // stopka ekranu rejestracji
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
