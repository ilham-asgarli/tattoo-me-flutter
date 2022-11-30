import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/implementations/auth_repository.dart';
import 'package:tattoo/domain/repositories/auth/implementations/email_auth_repository.dart';
import 'package:tattoo/domain/usecases/auth/interfaces/email_auth_interface.dart';

class EmailAuthUseCase extends EmailAuthInterface {
  EmailAuthRepository emailAuthRepository = EmailAuthRepository();
  AuthRepository authRepository = AuthRepository();

  @override
  Future<BaseResponse> signUpWithEmailAndPassword(UserModel userModel) async {
    BaseResponse baseResponse =
        await emailAuthRepository.signUpWithEmailAndPassword(userModel);
    if (baseResponse is BaseSuccess) {
      baseResponse = await authRepository.signOut();
    }
    return baseResponse;
  }
}
