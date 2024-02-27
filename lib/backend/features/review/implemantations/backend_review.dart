import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/auth/backend_user_model.dart';
import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/auth/user_model.dart';

import '../../../utils/constants/app/app_constants.dart';
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
              balance: FieldValue.increment(AppBackConstants.reviewAward),
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
