import 'package:tattoo/backend/features/auth/implementations/backend_anonymous_auth_implementation.dart';
import 'package:tattoo/core/network/interfaces/response_model.dart';
import 'package:tattoo/core/network/models/response_model.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/interfaces/anonymous_auth_interface.dart';

class AnonymousAuthImplementation extends AnonymousAuthInterface {
  final BackendAnonymousAuthImplementation auth =
      BackendAnonymousAuthImplementation();

  @override
  Future<IResponseModel<void>> signInAnonymously(
    UserModel userModel,
  ) async {
    auth.signInAnonymously(userModel);
    return ResponseModel();
  }
}
