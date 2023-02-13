import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/utils/logic/errors/auth/user_not_found_error.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';

class FirestoreException {
  BaseResponse<T> firestore<T>(Object exception) {
    if (exception is FirebaseException) {
      switch (exception.code) {
        case 'not-found':
          return UserNotFoundError(message: exception.message);
        default:
          return BaseError(message: exception.message);
      }
    }

    return BaseError(message: "");
  }
}
