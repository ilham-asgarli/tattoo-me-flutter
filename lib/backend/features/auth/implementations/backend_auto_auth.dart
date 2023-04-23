import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/base/models/base_error.dart';
import '../../../../core/base/models/base_response.dart';
import '../../../../core/base/models/base_success.dart';
import '../../../../domain/models/auth/user_model.dart';
import '../../../core/exceptions/firestore/firestore_exception.dart';
import '../../../models/auth/backend_user_model.dart';
import '../../../utils/constants/firebase/users/users_collection_constants.dart';
import '../interfaces/backend_auto_auth_interface.dart';

class BackendAutoAuth extends BackendAutoAuthInterface {
  FirestoreException firestoreException = FirestoreException();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection(UsersCollectionConstants.users);

  @override
  Future<BaseResponse<UserModel>> createUser({UserModel? userModel}) async {
    try {
      UserModel model = UserModel(
        id: userModel?.id,
        email: userModel?.email,
        password: userModel?.password,
        balance: 30,
        isBoughtFirstDesign: false,
      );
      BackendUserModel backendUserModel =
          BackendUserModel.from(userModel: model);
      backendUserModel.createdDate = FieldValue.serverTimestamp();
      backendUserModel.lastAppEntryDate = FieldValue.serverTimestamp();

      if (backendUserModel.id == null) {
        DocumentReference documentReference =
            await users.add(backendUserModel.toJson());
        backendUserModel.id = documentReference.id;
      } else {
        await users.doc(model.id).set(backendUserModel.toJson());
      }

      return BaseSuccess<UserModel>(
          data: backendUserModel.to(userModel: backendUserModel));
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  @override
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel) async {
    BackendUserModel backendUserModel =
        BackendUserModel.from(userModel: userModel);
    backendUserModel.lastAppEntryDate = FieldValue.serverTimestamp();

    try {
      await users.doc(userModel.id).update(backendUserModel.toJson());
      return BaseSuccess();
    } catch (e) {
      return firestoreException.firestore(e);
    }
  }

  @override
  Future<BaseResponse> updateBalance(
    UserModel userModel,
    int value,
  ) async {
    BackendUserModel backendUserModel =
        BackendUserModel.from(userModel: userModel);
    backendUserModel.balance = FieldValue.increment(value);

    try {
      await users.doc(userModel.id).update(backendUserModel.toJson());
      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> buyFirstDesign(UserModel userModel) async {
    try {
      await firestore.runTransaction((transaction) async {
        DocumentReference userDocument = users.doc(userModel.id);

        BackendUserModel backendUserModel = BackendUserModel().fromJson(
            (await transaction.get(userDocument)).data()
                as Map<String, dynamic>);

        if (!(backendUserModel.isBoughtFirstDesign ?? false) &&
            backendUserModel.balance >= 30) {
          transaction.update(
              userDocument,
              BackendUserModel(
                balance: FieldValue.increment(-30),
                isBoughtFirstDesign: true,
              ).toJson());
        }
      }, maxAttempts: 1).catchError((e) {
        throw e;
      });

      return BaseSuccess();
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  @override
  Future<BaseResponse<UserModel>> getUserWithId(String userId) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(userId).get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        BackendUserModel backendUserModel = BackendUserModel().fromJson(data);
        backendUserModel.id = userId;

        return BaseSuccess<UserModel>(
          data: BackendUserModel().to(
            userModel: backendUserModel,
          ),
        );
      } else {
        return BaseSuccess<UserModel>(data: UserModel());
      }
    } catch (e) {
      return BaseError(message: e.toString());
    }
  }

  @override
  Stream<BaseResponse<UserModel>> getUserInfo(String userId) async* {
    try {
      Stream<DocumentSnapshot> userSnapshots = users.doc(userId).snapshots();
      await for (var userSnapshot in userSnapshots) {
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          BackendUserModel backendUserModel =
              BackendUserModel().fromJson(userData);
          backendUserModel.id = userId;

          yield BaseSuccess(
            data: BackendUserModel().to(
              userModel: backendUserModel,
            ),
          );
        }
      }
    } catch (e) {
      BaseError(message: e.toString());
    }
  }
}
