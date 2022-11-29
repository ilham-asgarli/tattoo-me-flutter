import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_email_auth_interface.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import 'backend_auth_implementations.dart';

class BackendEmailAuthImplementation extends BackendEmailAuthInterface {
  final BackendAuthImplementation auth = BackendAuthImplementation();

  @override
  Future<BaseResponse> signUpWithEmailAndPassword(UserModel userModel) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
      return BaseSuccess();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          return BaseError();
        case 'email-already-in-use':
          return BaseError();
        default:
          return BaseError();
      }
    } catch (e) {
      return BaseError();
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
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return BaseError();
        case 'wrong-password':
          return BaseError();
        default:
          return BaseError();
      }
    } catch (e) {
      return BaseError();
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
}
