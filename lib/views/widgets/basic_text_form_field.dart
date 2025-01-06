/* import 'package:flutter/material.dart';

/* class BasicTextFormField extends StatelessWidget {
  final String initialValue;

  const BasicTextFormField({super.key, this.initialValue = ''});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
    );
  }
}
*/
class BasicTextFormField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;

  const BasicTextFormField(required String hintText, {
    Key? key,
    required this.hintText,
    required this.icon,
    this.obscureText = false, required icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class BasicTextFormField extends StatelessWidget {
  final String hintText;
  final Widget? iconWidget;
  final bool obscureText;
  final Widget? suffixIcon;

  const BasicTextFormField({
    Key? key,
    required this.hintText,
    this.iconWidget,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390,
      height: 50,
      child: TextFormField(
        obscureText: obscureText,
        decoration: _buildDecoration(),
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hintText,
      hintStyle: hintText == 'Email or User Name'
          ? const TextStyle(
        color: Color(0x4D000000), // Czarny (#000000) z 30% widocznością
        shadows: [
          Shadow(
            offset: Offset(0, 1.5), // Kierunek od góry do dołu
            blurRadius: 10.0, // Subtelniejszy cień
            color: Colors.black38, // Delikatniejszy kolor
          ),
        ],
      )
          : const TextStyle(
        color: Color(0x4D000000), // Czarny (#000000) z 30% widocznością
      ),
      prefixIcon: iconWidget,
      suffixIcon: suffixIcon ?? const SizedBox.shrink(), // Domyślny pusty widget
      border: _buildOutlineInputBorder(MyColors.plumColor),
      enabledBorder: _buildOutlineInputBorder(MyColors.plumColor),
      focusedBorder: _buildOutlineInputBorder(MyColors.purpleColor),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: borderColor,
        width: 2.0,
      ),
    );
  }
}
