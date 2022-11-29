import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';

class AuthException {
  BaseResponse auth(Object exception) {
    if (exception is FirebaseAuthException) {
      switch (exception.code) {
        case 'user-not-found':
          return BaseError(message: exception.message);
        case 'wrong-password':
          return BaseError(message: exception.message);
        case 'weak-password':
          return BaseError(message: exception.message);
        case 'email-already-in-use':
          return BaseError(message: exception.message);
        case "provider-already-linked":
          return BaseError(message: exception.message);
        case "invalid-credential":
          return BaseError(message: exception.message);
        case "credential-already-in-use":
          return BaseError(message: exception.message);
        case "operation-not-allowed":
          return BaseError(message: exception.message);
        default:
          return BaseError(message: exception.message);
      }
    }

    return BaseError(message: "");
  }
}
