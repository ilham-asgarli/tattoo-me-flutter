import 'package:tattoo/backend/features/auth/implementations/backend_anonymous_auth.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/domain/repositories/auth/interfaces/anonymous_auth_interface.dart';

class AnonymousAuthRepository extends AnonymousAuthInterface {
  final BackendAnonymousAuth auth = BackendAnonymousAuth();

  @override
  Future<BaseResponse> signInAnonymously() async {
    BaseResponse responseModel = await auth.signInAnonymously();
    return responseModel;
  }
}
