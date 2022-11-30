import '../../../../core/base/models/base_response.dart';

abstract class AuthInterface {
  Future<BaseResponse> getCurrentUser();
  Future<BaseResponse> getNotAnonymousCurrentUser();
  Future<BaseResponse> signOut();
}
