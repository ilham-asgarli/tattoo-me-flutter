import '../../../../backend/features/auth/implementations/backend_auto_auth.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../models/auth/user_model.dart';
import '../interfaces/auto_auth_interface.dart';

class AutoAuthRepository extends AutoAuthInterface {
  final BackendAutoAuth backendAutoAuth = BackendAutoAuth();

  @override
  Future<BaseResponse<UserModel>> createUser() async {
    BaseResponse<UserModel> baseResponse = await backendAutoAuth.createUser();
    return baseResponse;
  }

  @override
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel) async {
    BaseResponse baseResponse =
        await backendAutoAuth.updateLastAppEntryDate(userModel);
    return baseResponse;
  }

  @override
  Future<BaseResponse<UserModel>> getUserWithId(String id) async {
    BaseResponse<UserModel> baseResponse =
        await backendAutoAuth.getUserWithId(id);
    return baseResponse;
  }

  @override
  Stream<BaseResponse<UserModel>> getUserInfo(String id) {
    return backendAutoAuth.getUserInfo(id);
  }

  @override
  Future<BaseResponse> updateBalance(UserModel userModel, int value) async {
    BaseResponse baseResponse =
        await backendAutoAuth.updateBalance(userModel, value);
    return baseResponse;
  }
}
