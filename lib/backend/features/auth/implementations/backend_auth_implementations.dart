import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_auth_interface.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../domain/models/auth/user_model.dart';

class BackendAuthImplementation extends BackendAuthInterface {
  @override
  Future<BaseResponse> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return BaseSuccess();
    } catch (e) {
      return BaseError(message: "");
    }
  }

  @override
  Future<BaseResponse> linkWithCredential(AuthCredential authCredential) async {
    try {
      final credential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(authCredential);
      return BaseSuccess(data: UserModel(email: "", password: ""));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          return BaseError(message: "");
        case "invalid-credential":
          return BaseError(message: "");
        case "credential-already-in-use":
          return BaseError(message: "");
        default:
          return BaseError(message: "");
      }
    } catch (e) {
      return BaseError(message: "");
    }
  }
}
