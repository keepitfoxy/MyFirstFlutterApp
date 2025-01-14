import 'package:flutter/material.dart';
import 'package:lisiecka_aplikacje_mobilne/utils/my_colors.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
