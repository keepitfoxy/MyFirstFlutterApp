import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/views/login/login_view.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
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
                  MaterialPageRoute(builder: (context) => const LoginView()),
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
    );
  }
}
