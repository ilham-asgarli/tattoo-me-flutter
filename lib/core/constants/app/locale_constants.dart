import 'dart:ui';

class LocaleConstants {
  static const path = "assets/translations";

  static const enUS = Locale("en", "US");
  static const trTR = Locale("tr", "TR");
  static const deDE = Locale("de", "DE");
  static const esES = Locale("es", "ES");
  static const itIT = Locale("it", "IT");

  static List<Locale> get supportedLocales => [
        LocaleConstants.trTR,
        LocaleConstants.enUS,
        LocaleConstants.deDE,
        LocaleConstants.esES,
        LocaleConstants.itIT,
      ];
}
