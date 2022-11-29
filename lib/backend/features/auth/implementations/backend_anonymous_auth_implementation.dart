import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_response.dart';
import '../../../core/exceptions/auth/auth_exception.dart';
import '../interfaces/backend_anonymous_auth_interface.dart';

class BackendAnonymousAuthImplementation extends BackendAnonymousAuthInterface {
  AuthException authException = AuthException();

  @override
  Future<BaseResponse> signInAnonymously() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      return BaseSuccess();
    } catch (e) {
      return authException.auth(e);
    }
  }
}
