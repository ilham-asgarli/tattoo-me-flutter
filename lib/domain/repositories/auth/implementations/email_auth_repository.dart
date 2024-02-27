import '../../../../backend/features/auth/implementations/backend_email_auth.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../models/auth/user_model.dart';

import '../interfaces/email_auth_interface.dart';

class EmailAuthRepository extends EmailAuthInterface {
  final BackendEmailAuth emailAuth = BackendEmailAuth();

  @override
  Future<BaseResponse<UserModel>> signUpWithEmailAndPassword(
    UserModel userModel,
  ) async {
    BaseResponse<UserModel> baseResponse =
        await emailAuth.signUpWithEmailAndPassword(userModel);
    return baseResponse;
  }

  @override
  Future<BaseResponse<UserModel>> signInWithEmailAndPassword(
    UserModel userModel,
  ) async {
    BaseResponse<UserModel> baseResponse =
        await emailAuth.signInWithEmailAndPassword(userModel);
    return baseResponse;
  }

  @override
  Future<BaseResponse> linkWithEmailAndPassword(
    UserModel userModel,
  ) async {
    BaseResponse baseResponse =
        await emailAuth.linkWithEmailAndPassword(userModel);
    return baseResponse;
  }

  @override
  bool emailVerified() {
    return emailAuth.emailVerified();
  }

  @override
  Future<BaseResponse> sendPasswordResetEmail(String email) async {
    BaseResponse baseResponse = await emailAuth.sendPasswordResetEmail(email);
    return baseResponse;
  }
}
