import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/models/auth/backend_user_model.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../../../utils/constants/firebase/users/users_collection_constants.dart';
import '../interfaces/backend_review_interface.dart';

class BackendReview extends BackendReviewInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference users =
      FirebaseFirestore.instance.collection(UsersCollectionConstants.users);

  @override
  Future<BaseResponse> makeReview(UserModel userModel) async {
    try {
      await firestore.runTransaction((transaction) async {
        DocumentReference userDocument = users.doc(userModel.id);
        transaction.update(
            userDocument,
            BackendUserModel(
              balance: FieldValue.increment(30),
              isFirstOrderInsufficientBalance: false,
            ).toJson());
      }, maxAttempts: 1).catchError((e) {
        throw e;
      });

      return BaseSuccess();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }
}
