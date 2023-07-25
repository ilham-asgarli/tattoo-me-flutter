import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CreditIcon extends StatelessWidget {
  const CreditIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: HexColor("#87BB60"),
      ),
      child: const Icon(
        Icons.star_border_sharp,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}
