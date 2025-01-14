import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_images.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/login_widgets/login_form.dart';
import 'package:lisiecka_aplikacje_mobilne/views/widgets/login_widgets/login_footer.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

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
                const LoginForm(),
                const SizedBox(height: 150),
                const LoginFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _signInText {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Sign in',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: MyColors.purpleColor,
        ),
      ),
    );
  }
}
