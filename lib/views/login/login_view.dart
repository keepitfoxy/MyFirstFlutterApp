import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/register/register_view.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/basic_text_form_field.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/confirmation_button.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscurePassword = true;

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

                // Email field
                BasicTextFormField(
                  hintText: 'Email or User Name',
                  iconWidget: Image.asset(MyImages.user, height: 24, width: 24),
                ),

                const SizedBox(height: 40),

                // Password field
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

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forget Password ?',
                      style: TextStyle(
                        color: MyColors.purpleColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Sign In button
                ConfirmationButton(
                  text: 'Sign in',
                  onPressed: () {
                    // Navigate to Home or perform login
                  },
                ),

                const SizedBox(height: 150),

                // Sign Up link
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterView(),
                              ),
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
}

Widget get _signInText{
  return Align(
    alignment: Alignment.centerLeft,
    child: Text('Sign in',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: MyColors.purpleColor,
      ),
    ),
  );
}