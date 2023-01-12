import 'package:app_review/app_review.dart';

class InAppReviewHelper {
  static InAppReviewHelper instance = InAppReviewHelper._init();

  InAppReviewHelper._init();

  Future<void> request() async {
    if (await AppReview.isRequestReviewAvailable) {
      await AppReview.requestReview;
    } else {
      await AppReview.storeListing;
    }
  }
}
