import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/basic_text_form_field.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/confirmation_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true; // ukrywanie hasła
  bool _obscureConfirmPassword = true; // ukrywanie potwierdzenia hasła

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // wyrównanie elementów do lewej
      children: [
        // pole tekstowe dla imienia i nazwiska
        BasicTextFormField(
          hintText: 'Full Name', // podpowiedź w polu
          iconWidget: Image.asset(MyImages.user, height: 24, width: 24), // ikona użytkownika
        ),
        const SizedBox(height: 40), // odstęp między polami
        // pole tekstowe dla adresu e-mail
        BasicTextFormField(
          hintText: 'Email', // podpowiedź w polu
          iconWidget: Image.asset(MyImages.email, height: 24, width: 24), // ikona e-mail
        ),
        const SizedBox(height: 40), // odstęp między polami
        // pole tekstowe dla hasła
        BasicTextFormField(
          hintText: 'Password', // podpowiedź w polu
          iconWidget: Icon(Icons.lock_outline, color: MyColors.purpleColor), // ikona kłódki
          obscureText: _obscurePassword, // ukrywanie hasła
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscurePassword = !_obscurePassword; // przełączanie widoczności hasła
              });
            },
            child: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility, // ikona widoczności
              color: MyColors.purpleColor,
            ),
          ),
        ),
        const SizedBox(height: 40), // odstęp między polami
        // pole tekstowe do potwierdzenia hasła
        BasicTextFormField(
          hintText: 'Confirm Password', // podpowiedź w polu
          iconWidget: Icon(Icons.lock_outline, color: MyColors.purpleColor), // ikona kłódki
          obscureText: _obscureConfirmPassword, // ukrywanie potwierdzenia hasła
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword; // przełączanie widoczności hasła
              });
            },
            child: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, // ikona widoczności
              color: MyColors.purpleColor,
            ),
          ),
        ),
        const SizedBox(height: 80), // odstęp przed przyciskiem
        // przycisk do rejestracji
        ConfirmationButton(
          text: 'Sign Up', // tekst na przycisku
          onPressed: () {
            // logika rejestracji (do uzupełnienia)
          },
        ),
      ],
    );
  }
}
