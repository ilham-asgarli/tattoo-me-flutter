import 'package:tattoo/core/base/models/base_response.dart';

import '../../../../domain/models/auth/user_model.dart';

abstract class BackendAutoAuthInterface {
  Future<BaseResponse<UserModel>> createUser(UserModel userModel);
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel);
}