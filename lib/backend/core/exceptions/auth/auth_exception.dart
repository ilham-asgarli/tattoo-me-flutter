import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';

class AuthException {
  BaseResponse auth(Object exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'user-not-found':
          return BaseError(message: "");
        case 'wrong-password':
          return BaseError(message: "");
        case 'weak-password':
          return BaseError(message: "");
        case 'email-already-in-use':
          return BaseError(message: "");
        case "provider-already-linked":
          return BaseError(message: "");
        case "invalid-credential":
          return BaseError(message: "");
        case "credential-already-in-use":
          return BaseError(message: "");
        case "operation-not-allowed":
          return BaseError(message: "");
        default:
          return BaseError(message: "");
      }
    }

    return BaseError(message: "");
  }
}
