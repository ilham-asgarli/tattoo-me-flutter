import 'package:in_app_review/in_app_review.dart';

class InAppReviewHelper {
  static InAppReviewHelper instance = InAppReviewHelper._init();

  InAppReviewHelper._init();

  final InAppReview inAppReview = InAppReview.instance;

  Future<void> request() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }
}
