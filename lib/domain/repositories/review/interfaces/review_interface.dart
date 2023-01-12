import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/auth/user_model.dart';

abstract class ReviewInterface {
  Future<BaseResponse> makeReview(UserModel userModel);
}
