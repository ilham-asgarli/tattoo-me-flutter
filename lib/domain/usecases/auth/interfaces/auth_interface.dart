import '../../../../core/base/models/base_response.dart';
import '../../../models/auth/user_model.dart';

abstract class AuthInterface {
  Future<BaseResponse> signOut();
  bool isSignedIn();
  Future<BaseResponse<UserModel>> deleteAccount(String userId);
}
