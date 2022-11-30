import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_email_auth_interface.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../core/exceptions/auth/auth_exception.dart';
import 'backend_auth_implementations.dart';

class BackendEmailAuthImplementation extends BackendEmailAuthInterface {
  final BackendAuthImplementation auth = BackendAuthImplementation();
  AuthException authException = AuthException();

  @override
  Future<BaseResponse> signUpWithEmailAndPassword(UserModel userModel) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      return BaseSuccess();
    } catch (e) {
      return authException.auth(e);
    }
  }

  @override
  Future<BaseResponse> signInWithEmailAndPassword(UserModel userModel) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      return BaseSuccess();
    } catch (e) {
      return authException.auth(e);
    }
  }

  @override
  AuthCredential getCredential(UserModel userModel) {
    return EmailAuthProvider.credential(
      email: userModel.email,
      password: userModel.password,
    );
  }

  @override
  Future<BaseResponse> linkWithEmailAndPassword(UserModel userModel) async {
    AuthCredential authCredential = getCredential(userModel);
    return await auth.linkWithCredential(authCredential);
  }

  @override
  bool emailVerified() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }
    return user.emailVerified;
  }
}
