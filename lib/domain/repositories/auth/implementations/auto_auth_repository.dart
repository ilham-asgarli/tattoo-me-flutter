import 'package:tattoo/backend/features/auth/implementations/backend_auto_auth.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/interfaces/auto_auth_interface.dart';

class AutoAuthRepository extends AutoAuthInterface {
  final BackendAutoAuth backendAutoAuth = BackendAutoAuth();

  @override
  Future<BaseResponse<UserModel>> createUser(UserModel userModel) async {
    BaseResponse<UserModel> baseResponse =
        await backendAutoAuth.createUser(userModel);
    return baseResponse;
  }

  @override
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel) async {
    BaseResponse baseResponse =
        await backendAutoAuth.updateLastAppEntryDate(userModel);
    return baseResponse;
  }
}
