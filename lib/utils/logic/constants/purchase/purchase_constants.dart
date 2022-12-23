class PurchaseConstants {
  static List<String> all = [
    ...inAppProducts.keys,
    ...subscriptions.keys,
  ];

  static const Map<String, int> inAppProducts = {
    "credits_30": 30,
    "credits_90": 90,
    "credits_150": 150,
    "credits_300": 300,
    "credits_600": 600,
    "credits_900": 900,
    "credits_1800": 1800,
  };

  static const Map<String, int> subscriptions = {
    "sub_credits_150": 150,
    "sub_credits_300": 300,
    "sub_credits_600": 600,
    "sub_credits_900": 900,
    "sub_credits_1800": 1800,
  };
}
