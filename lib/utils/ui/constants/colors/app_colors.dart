import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  static Color mainColor = HexColor("#0d0d0d"); //Colors.black.withAlpha(205)
  static Color secondColor = Colors.white;
  static Color tertiary = HexColor("#333333");

  static const Color light = Colors.white;
  static Color dark = Colors.grey[850]!;

  static Color shimmerColor = mainColor;
  static Color shimmerBaseColor = mainColor.withAlpha(100);
  static Color shimmerHighLightColor = mainColor.withAlpha(50);

  static Color defaultShimmerBaseColor = Colors.grey[300]!;
  static Color defaultShimmerHighLightColor = Colors.grey[100]!;
}
