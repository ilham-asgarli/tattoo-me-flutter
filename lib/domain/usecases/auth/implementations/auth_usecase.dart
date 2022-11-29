import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../backend/features/auth/implementations/backend_auth_implementations.dart';
import '../../../../core/base/models/base_response.dart';
import '../interfaces/auth_interface.dart';

class AuthUseCase extends AuthInterface {
  final BackendAuthImplementation auth = BackendAuthImplementation();

  @override
  Future<bool> isSignedIn() async {
    BaseResponse baseResponse = await auth.getCurrentUser();
    return baseResponse is BaseSuccess;
  }
}
