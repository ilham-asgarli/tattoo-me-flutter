import '../../../../core/network/interfaces/response_model.dart';

abstract class AuthInterface {
  Future<IResponseModel<void>> signOut();
}
