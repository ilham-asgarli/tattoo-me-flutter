import 'package:tattoo/backend/features/auth/implementations/backend_email_auth_implementation.dart';
import 'package:tattoo/core/network/interfaces/response_model.dart';
import 'package:tattoo/core/network/models/response_model.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../interfaces/email_auth_interface.dart';

class EmailAuthImplementation extends EmailAuthInterface {
  final BackendEmailAuthImplementation emailAuth =
      BackendEmailAuthImplementation();

  @override
  Future<IResponseModel<void>> signUpWithEmailAndPassword(
    UserModel userModel,
  ) async {
    emailAuth.signUpWithEmailAndPassword(userModel);
    return ResponseModel();
  }

  @override
  Future<IResponseModel<void>> signInWithEmailAndPassword(
    UserModel userModel,
  ) async {
    emailAuth.signInWithEmailAndPassword(userModel);
    return ResponseModel();
  }

  @override
  IResponseModel<void> linkWithEmailAndPassword(
    UserModel userModel,
  ) {
    emailAuth.linkWithEmailAndPassword(userModel);
    return ResponseModel();
  }
}
