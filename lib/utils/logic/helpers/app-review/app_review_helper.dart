import 'package:app_review/app_review.dart';

class AppReviewHelper {
  static AppReviewHelper instance = AppReviewHelper._init();

  AppReviewHelper._init();

  Future<void> openStore() async {
    String? details = await AppReview.storeListing;
  }

  Future<bool> requestReview() async {
    bool isRequestReviewAvailable = await AppReview.isRequestReviewAvailable;
    print("Status: $isRequestReviewAvailable");

    if (isRequestReviewAvailable) {
      String? details = await AppReview.requestReview;
      print("Available: $details");
    }

    return isRequestReviewAvailable;
  }
}
