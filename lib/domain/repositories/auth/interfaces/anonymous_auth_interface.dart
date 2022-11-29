import '../../../../core/base/models/base_response.dart';

abstract class AnonymousAuthInterface {
  Future<BaseResponse> signInAnonymously();
}
