import '../../../../core/base/models/base_response.dart';

abstract class AuthInterface {
  Future<BaseResponse> signOut();
  bool isSignedIn();
}
