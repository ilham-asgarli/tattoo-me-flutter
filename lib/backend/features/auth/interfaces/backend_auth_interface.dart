import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendAuthInterface {
  BaseResponse<UserModel> getCurrentUser();

  Future<BaseResponse> signOut();

  Future<BaseResponse<UserModel>> linkWithCredential(
      AuthCredential authCredential);
}
