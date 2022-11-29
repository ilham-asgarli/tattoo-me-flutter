import 'dart:ui';

class LocaleConstants {
  static const path = "assets/translations";

  static const enUS = Locale("en", "US");
  static const trTR = Locale("tr", "TR");

  static List<Locale> get supportedLocales => [
        LocaleConstants.trTR,
        LocaleConstants.enUS,
      ];
}
