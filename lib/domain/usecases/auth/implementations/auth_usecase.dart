import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../models/auth/user_model.dart';
import '../../../repositories/auth/implementations/auth_repository.dart';
import '../../../repositories/auth/implementations/auto_auth_repository.dart';
import '../interfaces/auth_interface.dart';

class AuthUseCase extends AuthInterface {
  final AuthRepository authRepository = AuthRepository();
  final AutoAuthRepository autoAuthRepository = AutoAuthRepository();

  @override
  Future<BaseResponse<UserModel>> signOut() async {
    BaseResponse<UserModel> baseResponse =
        await autoAuthRepository.createUser();
    if (baseResponse is BaseSuccess) {
      BaseResponse signOutResponse = await authRepository.signOut();

      if (signOutResponse is BaseSuccess) {
        return baseResponse;
      } else {
        BaseError();
      }
    }
    return BaseError();
  }

  @override
  bool isSignedIn() {
    BaseResponse<UserModel> baseResponse = authRepository.getCurrentUser();
    return baseResponse is BaseSuccess<UserModel>;
  }

  @override
  Future<BaseResponse<UserModel>> deleteAccount() async {
    BaseResponse<UserModel> baseResponse =
    await autoAuthRepository.createUser();
    if (baseResponse is BaseSuccess) {
      BaseResponse signOutResponse = await authRepository.deleteAccount();

      if (signOutResponse is BaseSuccess) {
        return baseResponse;
      } else {
        BaseError();
      }
    }
    return BaseError();
  }
}
