import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../../domain/models/auth/user_model.dart';

abstract class BackendEmailAuthInterface {
  Future<BaseResponse> signUpWithEmailAndPassword(UserModel userModel);

  Future<BaseResponse> signInWithEmailAndPassword(UserModel userModel);

  AuthCredential getCredential(UserModel userModel);

  Future<BaseResponse> linkWithEmailAndPassword(UserModel userModel);

  bool emailVerified();
}
