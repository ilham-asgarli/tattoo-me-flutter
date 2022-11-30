import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/base/models/base_response.dart';

abstract class BackendAuthInterface {
  Future<BaseResponse> getCurrentUser();

  Future<BaseResponse> getNotAnonymousCurrentUser();

  Future<BaseResponse> signOut();

  Future<BaseResponse> linkWithCredential(AuthCredential authCredential);
}
