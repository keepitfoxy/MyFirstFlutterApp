import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class BasicTextFormField extends StatelessWidget {
  final String hintText; // podpowiedź tekstowa w polu
  final Widget? iconWidget; // opcjonalna ikona po lewej stronie
  final bool obscureText; // ustawienie ukrywania tekstu (np. dla hasła)
  final Widget? suffixIcon; // opcjonalna ikona po prawej stronie
  final TextEditingController? controller; // kontroler pola tekstowego

  const BasicTextFormField({
    Key? key,
    required this.hintText, // inicjalizacja podpowiedzi
    this.iconWidget, // inicjalizacja ikony
    this.obscureText = false, // domyślne ustawienie dla ukrywania tekstu
    this.suffixIcon, // inicjalizacja ikony po prawej stronie
    this.controller, // inicjalizacja kontrolera
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390, // szerokość pola tekstowego
      height: 50, // wysokość pola tekstowego
      child: TextFormField(
        controller: controller, // przypisanie kontrolera
        obscureText: obscureText, // ustawienie ukrywania tekstu
        decoration: _buildDecoration(), // dekoracja pola tekstowego
      ),
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      hintText: hintText, // tekst podpowiedzi w polu
      hintStyle: hintText == 'Email or User Name'
          ? const TextStyle(
        color: Color(0x4D000000), // kolor tekstu z 30% widocznością
        shadows: [
          Shadow(
            offset: Offset(0, 1.5), // cień od góry do dołu
            blurRadius: 10.0, // delikatny efekt rozmycia
            color: Colors.black38, // kolor cienia
          ),
        ],
      )
          : const TextStyle(
        color: Color(0x4D000000), // kolor tekstu z 30% widocznością
      ),
      prefixIcon: iconWidget, // ikona po lewej stronie
      suffixIcon: suffixIcon ?? const SizedBox.shrink(), // domyślny pusty widget, jeśli brak ikony
      border: _buildOutlineInputBorder(MyColors.plumColor), // obramowanie pola
      enabledBorder: _buildOutlineInputBorder(MyColors.plumColor), // obramowanie w stanie aktywnym
      focusedBorder: _buildOutlineInputBorder(MyColors.purpleColor), // obramowanie w stanie skupienia
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15), // zaokrąglenie rogów
      borderSide: BorderSide(
        color: borderColor, // kolor obramowania
        width: 2.0, // grubość obramowania
      ),
    );
  }
}
