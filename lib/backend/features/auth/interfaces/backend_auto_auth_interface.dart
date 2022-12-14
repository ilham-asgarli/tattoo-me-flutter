import 'package:tattoo/core/base/models/base_response.dart';

import '../../../../domain/models/auth/user_model.dart';

abstract class BackendAutoAuthInterface {
  Future<BaseResponse<UserModel>> createUser({String? userId});
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel);
  Future<BaseResponse<UserModel>> getUserWithId(String id);
  Stream<BaseResponse<UserModel>> getUserInfo(String userId);
}
