import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/backend/features/auth/interfaces/backend_auth_interface.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../core/exceptions/auth/auth_exception.dart';

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
}
