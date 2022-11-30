import 'package:tattoo/domain/repositories/auth/implementations/auth_repository.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../repositories/auth/implementations/anonymous_auth_repository.dart';
import '../interfaces/auth_interface.dart';

class AuthUseCase extends AuthInterface {
  final AuthRepository authRepository = AuthRepository();
  final AnonymousAuthRepository anonymousAuth = AnonymousAuthRepository();

  @override
  Future<BaseResponse> signOut() async {
    BaseResponse baseResponse = await authRepository.signOut();
    baseResponse = await anonymousAuth.signInAnonymously();
    return baseResponse;
  }
}
