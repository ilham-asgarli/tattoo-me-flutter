import '../../../../core/base/models/base_response.dart';

abstract class BackendAnonymousAuthInterface {
  Future<BaseResponse> signInAnonymously();
}
