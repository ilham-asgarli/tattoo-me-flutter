import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/auth/user_model.dart';

abstract class BackendReviewInterface {
  Future<BaseResponse> makeReview(UserModel userModel);
}
