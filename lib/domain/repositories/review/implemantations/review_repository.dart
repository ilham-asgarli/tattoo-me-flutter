import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../backend/features/review/implemantations/backend_review.dart';
import '../interfaces/review_interface.dart';

class ReviewRepository extends ReviewInterface {
  BackendReview backendReview = BackendReview();

  @override
  Future<BaseResponse> makeReview(UserModel userModel) async {
    BaseResponse baseResponse = await backendReview.makeReview(userModel);
    return baseResponse;
  }
}
