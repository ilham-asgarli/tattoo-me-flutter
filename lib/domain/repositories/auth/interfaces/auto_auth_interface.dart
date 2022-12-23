import '../../../../core/base/models/base_response.dart';
import '../../../models/auth/user_model.dart';

abstract class AutoAuthInterface {
  Future<BaseResponse> createUser();
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel);
  Future<BaseResponse<UserModel>> getUserWithId(String id);
  Stream<BaseResponse<UserModel>> getUserInfo(String id);
  Future<BaseResponse> updateBalance(UserModel userModel, int value);
}
