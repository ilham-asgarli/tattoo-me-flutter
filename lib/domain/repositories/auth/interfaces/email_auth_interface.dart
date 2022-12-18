import '../../../../core/base/models/base_response.dart';
import '../../../models/auth/user_model.dart';

abstract class EmailAuthInterface {
  Future<BaseResponse> signUpWithEmailAndPassword(UserModel userModel);
  Future<BaseResponse> signInWithEmailAndPassword(UserModel userModel);
  Future<BaseResponse> linkWithEmailAndPassword(UserModel userModel);
  bool emailVerified();
  Future<BaseResponse> sendPasswordResetEmail(String email);
}
