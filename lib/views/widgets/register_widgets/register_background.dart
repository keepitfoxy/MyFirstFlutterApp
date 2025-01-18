import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // dodanie okręgu w prawym górnym rogu ekranu
          top: -70,
          right: -5,
          child: Container(
            width: 128, // szerokość okręgu
            height: 128, // wysokość okręgu
            decoration: BoxDecoration(
              color: MyColors.purpleColor.withOpacity(1), // kolor okręgu
              shape: BoxShape.circle, // kształt okręgu
            ),
          ),
        ),
        Positioned(
          // dodanie większego okręgu za pierwszym
          top: -50,
          right: -80,
          child: Container(
            width: 142, // szerokość okręgu
            height: 142, // wysokość okręgu
            decoration: BoxDecoration(
              color: MyColors.lilacColor.withOpacity(1), // kolor okręgu
              shape: BoxShape.circle, // kształt okręgu
            ),
          ),
        ),
      ],
    );
  }
}
