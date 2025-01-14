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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BasicTextFormField(
          hintText: 'Full Name',
          iconWidget: Image.asset(MyImages.user, height: 24, width: 24),
        ),
        const SizedBox(height: 40),
        BasicTextFormField(
          hintText: 'Email',
          iconWidget: Image.asset(MyImages.email, height: 24, width: 24),
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
        ),
        const SizedBox(height: 40),
        BasicTextFormField(
          hintText: 'Confirm Password',
          iconWidget: Icon(Icons.lock_outline, color: MyColors.purpleColor),
          obscureText: _obscureConfirmPassword,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
            child: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: MyColors.purpleColor,
            ),
          ),
        ),
        const SizedBox(height: 80),
        ConfirmationButton(
          text: 'Sign Up',
          onPressed: () {
            // Logika rejestracji
          },
        ),
      ],
    );
  }
}
