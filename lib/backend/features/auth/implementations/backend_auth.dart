import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../core/encrypt/core_encrypt.dart';
import '../../../core/exceptions/auth/auth_exception.dart';
import '../interfaces/backend_auth_interface.dart';
import 'backend_auto_auth.dart';

class BackendAuth extends BackendAuthInterface {
  AuthException authException = AuthException();

  @override
  Future<BaseResponse> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse<UserModel>> linkWithCredential(
      AuthCredential authCredential) async {
    try {
      final credential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(authCredential);
      return BaseSuccess(data: UserModel(id: credential?.user?.uid));
    } catch (e) {
      return authException.auth(e);
    }
  }

  @override
  BaseResponse<UserModel> getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return BaseSuccess(data: UserModel(id: user.uid));
    } else {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> deleteAccount(String userId) async {
    try {
      BackendAutoAuth backendAutoAuth = BackendAutoAuth();
      BaseResponse<UserModel> userBaseResponse =
          await backendAutoAuth.getUserWithId(userId);

      if (userBaseResponse is BaseSuccess<UserModel>) {
        await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: userBaseResponse.data!.email!,
            password:
                CoreEncrypt().decryptFile(userBaseResponse.data!.password!),
          ),
        );

        await FirebaseAuth.instance.currentUser?.delete();
      } else {
        return BaseError();
      }

      return BaseSuccess();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }
}
