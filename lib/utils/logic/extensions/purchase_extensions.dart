import '../constants/enums/purchase_enums.dart';

extension InAppProductsExtension on InAppProducts {
  String get id {
    return switch (this) {
      InAppProducts.credits30 => "credits_30",
      InAppProducts.credits90 => "credits_90",
      InAppProducts.credits150 => "credits_150",
      InAppProducts.credits300 => "credits_300",
      InAppProducts.credits600 => "credits_600",
      InAppProducts.credits900 => "credits_900",
      InAppProducts.credits1800 => "credits_1800",
    };
  }

  int get credit {
    return switch (this) {
      InAppProducts.credits30 => 20,
      InAppProducts.credits90 => 90,
      InAppProducts.credits150 => 130,
      InAppProducts.credits300 => 310,
      InAppProducts.credits600 => 690,
      InAppProducts.credits900 => 1140,
      InAppProducts.credits1800 => 2520,
    };
  }

  int get extra {
    return switch (this) {
      InAppProducts.credits30 => 0,
      InAppProducts.credits90 => 14,
      InAppProducts.credits150 => 30,
      InAppProducts.credits300 => 56,
      InAppProducts.credits600 => 72,
      InAppProducts.credits900 => 90,
      InAppProducts.credits1800 => 110,
    };
  }
}

extension SubscriptionsExtension on Subscriptions {
  String get id {
    return switch (this) {
      Subscriptions.subCredits150 => "sub_credits_150",
      Subscriptions.subCredits300 => "sub_credits_300",
      Subscriptions.subCredits600 => "sub_credits_600",
      Subscriptions.subCredits900 => "sub_credits_900",
      Subscriptions.subCredits1800 => "sub_credits_1800",
    };
  }

  int get credit {
    return switch (this) {
      Subscriptions.subCredits150 => 150,
      Subscriptions.subCredits300 => 330,
      Subscriptions.subCredits600 => 740,
      Subscriptions.subCredits900 => 1320,
      Subscriptions.subCredits1800 => 3000,
    };
  }

  int get extra {
    return switch (this) {
      Subscriptions.subCredits150 => 50,
      Subscriptions.subCredits300 => 65,
      Subscriptions.subCredits600 => 85,
      Subscriptions.subCredits900 => 120,
      Subscriptions.subCredits1800 => 150,
    };
  }
}

extension PurchaseExtension on Purchase {
  List get values {
    return switch (this) {
      Purchase.inAppProduct => InAppProducts.values,
      Purchase.subscription => Subscriptions.values,
    };
  }
}
