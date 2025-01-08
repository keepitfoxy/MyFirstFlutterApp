import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/basic_text_form_field.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/confirmation_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Elementy tła
            _buildBackground(),

            // Główna zawartość widoku
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 59),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: MyColors.purpleColor,
                          size: 15,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: MyColors.purpleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 101),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: MyColors.purpleColor,
                    ),
                  ),

                  const SizedBox(height: 46),

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
                    iconWidget: Icon(
                      Icons.lock_outline,
                      color: MyColors.purpleColor,
                    ),
                    obscureText: _obscurePassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
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
                  ),

                  const SizedBox(height: 40),

                  BasicTextFormField(
                    hintText: 'Confirm Password',
                    iconWidget: Icon(
                      Icons.lock_outline,
                      color: MyColors.purpleColor,
                    ),
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                        color: MyColors.purpleColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 80),

                  // ConfirmationButton
                  ConfirmationButton(
                    text: 'Sign Up',
                    onPressed: () {
                      // Obsługa rejestracji
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            // Sign Up link
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign In',
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
    );
  }

  // Widget odpowiedzialny za elementy tła
  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -70,
          right: -5,
          child: Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: MyColors.purpleColor.withOpacity(1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: -50,
          right: -80,
          child: Container(
            width: 142,
            height: 142,
            decoration: BoxDecoration(
              color: MyColors.lilacColor.withOpacity(1),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
