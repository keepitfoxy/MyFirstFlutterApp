import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/register_widgets/register_background.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/register_widgets/register_footer.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/register_widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            const RegisterBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 59),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back_ios, color: MyColors.purpleColor, size: 15),
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
                  const RegisterForm(),
                  const Spacer(),
                  const RegisterFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
