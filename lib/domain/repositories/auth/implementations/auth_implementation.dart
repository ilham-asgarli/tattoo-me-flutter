import 'package:tattoo/backend/features/auth/implementations/backend_email_auth_implementation.dart';
import 'package:tattoo/core/network/interfaces/response_model.dart';
import 'package:tattoo/core/network/models/response_model.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';
import 'package:tattoo/domain/repositories/auth/interfaces/auth_interface.dart';

class AuthImplementation extends AuthInterface {
  final BackendEmailAuthImplementation auth = BackendEmailAuthImplementation();

  @override
  Future<IResponseModel<void>> signUpWithEmailAndPassword(
    UserModel userModel,
  ) async {
    auth.signUpWithEmailAndPassword(userModel);
    return ResponseModel();
  }

  @override
  Future<IResponseModel<void>> signInWithEmailAndPassword(
    UserModel userModel,
  ) async {
    auth.signInWithEmailAndPassword(userModel);
    return ResponseModel();
  }

  @override
  Future<IResponseModel<void>> signOut() async {
    auth.signOut();
    return ResponseModel();
  }
}
