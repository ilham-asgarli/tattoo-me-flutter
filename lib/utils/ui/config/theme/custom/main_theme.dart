import 'package:flutter/material.dart';

import '../../../constants/colors/app_colors.dart';
import '../interfaces/custom_theme.dart';

class MainTheme extends CustomTheme {
  static final MainTheme instance = MainTheme._init();

  MainTheme._init();

  @override
  ThemeData getTheme({
    required ThemeData modeThemeData,
  }) {
    return modeThemeData.copyWith(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.mainColor,
      ),
      scaffoldBackgroundColor: AppColors.mainColor,
      appBarTheme: const AppBarTheme(elevation: 0),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.secondColor,
        selectionColor: AppColors.tertiary,
        selectionHandleColor: AppColors.tertiary,
      ),
    );
  }
}
