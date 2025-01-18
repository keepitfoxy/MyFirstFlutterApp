import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class ConfirmationButton extends StatelessWidget {
  final String text; // tekst wyświetlany na przycisku
  final VoidCallback onPressed; // funkcja wywoływana po kliknięciu przycisku

  const ConfirmationButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 390, // szerokość przycisku
      height: 50, // wysokość przycisku
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent, // brak cienia
          backgroundColor: MyColors.lilacColor, // kolor tła przycisku
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // zaokrąglenie rogów
          ),
        ),
        onPressed: onPressed, // przypisanie funkcji wywoływanej po kliknięciu
        child: Text(
          text, // wyświetlany tekst
          style: TextStyle(
            fontFamily: 'Inter', // rodzina czcionki
            fontSize: 16, // rozmiar tekstu
            fontWeight: FontWeight.w700, // grubość czcionki
            color: MyColors.whiteColor, // kolor tekstu
          ),
        ),
      ),
    );
  }
}
