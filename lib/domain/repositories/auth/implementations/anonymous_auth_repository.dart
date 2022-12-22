import '../../../../backend/features/auth/implementations/backend_anonymous_auth.dart';
import '../../../../core/base/models/base_response.dart';
import '../interfaces/anonymous_auth_interface.dart';

class AnonymousAuthRepository extends AnonymousAuthInterface {
  final BackendAnonymousAuth auth = BackendAnonymousAuth();

  @override
  Future<BaseResponse> signInAnonymously() async {
    BaseResponse responseModel = await auth.signInAnonymously();
    return responseModel;
  }
}
