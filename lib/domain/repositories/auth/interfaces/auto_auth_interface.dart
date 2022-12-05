import '../../../../core/base/models/base_response.dart';
import '../../../models/auth/user_model.dart';

abstract class AutoAuthInterface {
  Future<BaseResponse> createUser(UserModel userModel);
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel);
  Future<BaseResponse<UserModel>> getUserWithId(String id);
}
