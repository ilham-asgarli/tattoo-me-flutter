import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/implementations/backend_auto_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_email_auth_interface.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../core/exceptions/auth/auth_exception.dart';
import 'backend_auth.dart';

class BackendEmailAuth extends BackendEmailAuthInterface {
  final BackendAuth auth = BackendAuth();
  final AuthException authException = AuthException();
  final BackendAutoAuth backendAutoAuth = BackendAutoAuth();

  @override
  Future<BaseResponse<UserModel>> signUpWithEmailAndPassword(
      UserModel userModel) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email ?? "",
        password: userModel.password ?? "",
      );

      userModel.id = credential.user?.uid;

      await credential.user?.sendEmailVerification();

      await FirebaseAuth.instance.signOut();

      final BaseResponse<UserModel> baseResponse =
          await backendAutoAuth.createUser(userModel: userModel);

      if (baseResponse is BaseSuccess<UserModel>) {
        return BaseSuccess<UserModel>(data: baseResponse.data);
      } else {
        return BaseError();
      }
    } catch (e) {
      return authException.auth(e);
    }
  }

  @override
  Future<BaseResponse<UserModel>> signInWithEmailAndPassword(
      UserModel userModel) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userModel.email ?? "",
        password: userModel.password ?? "",
      );
      userModel.id = credential.user?.uid;

      if (credential.user?.emailVerified ?? false) {
        return BaseSuccess<UserModel>(data: userModel);
      } else {
        return BaseError(message: "Email not verified");
      }
    } catch (e) {
      return authException.auth(e);
    }
  }

  @override
  AuthCredential getCredential(UserModel userModel) {
    return EmailAuthProvider.credential(
      email: userModel.email ?? "",
      password: userModel.password ?? "",
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

  @override
  Future<BaseResponse> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return BaseSuccess();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }
}
