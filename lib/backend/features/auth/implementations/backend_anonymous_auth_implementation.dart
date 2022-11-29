import 'package:firebase_auth/firebase_auth.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_success.dart';

import '../../../../core/base/models/base_response.dart';
import '../interfaces/backend_anonymous_auth_interface.dart';

class BackendAnonymousAuthImplementation extends BackendAnonymousAuthInterface {
  @override
  Future<BaseResponse> signInAnonymously() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      return BaseSuccess();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          return BaseError(message: "");
        default:
          return BaseError(message: "");
      }
    } catch (e) {
      return BaseError(message: "");
    }
  }
}
