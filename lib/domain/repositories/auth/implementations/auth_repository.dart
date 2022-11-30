import 'package:tattoo/domain/repositories/auth/interfaces/auth_interface.dart';

import '../../../../backend/features/auth/implementations/backend_auth_implementations.dart';
import '../../../../core/base/models/base_response.dart';

class AuthRepository extends AuthInterface {
  final BackendAuthImplementation auth = BackendAuthImplementation();

  @override
  Future<BaseResponse> signOut() async {
    BaseResponse baseResponse = await auth.signOut();
    return baseResponse;
  }

  @override
  Future<BaseResponse> getNotAnonymousCurrentUser() async {
    BaseResponse baseResponse = await auth.getNotAnonymousCurrentUser();
    return baseResponse;
  }

  @override
  Future<BaseResponse> getCurrentUser() async {
    BaseResponse baseResponse = await auth.getCurrentUser();
    return baseResponse;
  }
}
