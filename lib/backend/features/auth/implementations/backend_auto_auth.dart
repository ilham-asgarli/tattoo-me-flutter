import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/backend/models/auth/backend_user_model.dart';
import 'package:tattoo/backend/utils/constants/firebase/users/users_collection_constants.dart';
import 'package:tattoo/core/base/models/base_error.dart';
import 'package:tattoo/core/base/models/base_response.dart';
import 'package:tattoo/core/base/models/base_success.dart';
import 'package:tattoo/domain/models/auth/user_model.dart';

import '../interfaces/backend_auto_auth_interface.dart';

class BackendAutoAuth extends BackendAutoAuthInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users =
      FirebaseFirestore.instance.collection(UsersCollectionConstants.users);

  @override
  Future<BaseResponse<UserModel>> createUser({String? userId}) async {
    try {
      UserModel userModel = UserModel(
        id: userId,
        balance: 30,
        createdDate: DateTime.now(),
        lastAppEntryDate: DateTime.now(),
      );
      BackendUserModel backendUserModel =
          BackendUserModel.from(userModel: userModel);

      if (backendUserModel.id == null) {
        DocumentReference documentReference =
            await users.add(backendUserModel.toJson());
        backendUserModel.id = documentReference.id;
      } else {
        await users.doc(userModel.id).set(backendUserModel.toJson());
      }

      return BaseSuccess<UserModel>(
          data: backendUserModel.to(userModel: backendUserModel));
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse> updateLastAppEntryDate(UserModel userModel) async {
    userModel.lastAppEntryDate = DateTime.now();

    try {
      await users
          .doc(userModel.id)
          .update(BackendUserModel.from(userModel: userModel).toJson());
      return BaseSuccess();
    } catch (e) {
      return BaseError();
    }
  }

  @override
  Future<BaseResponse<UserModel>> getUserWithId(String id) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(id).get();
      Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        return BaseSuccess<UserModel>(
          data: BackendUserModel().to(
            userModel: BackendUserModel(
              id: documentSnapshot.id,
              balance: data["balance"],
              createdDate: data["createdDate"],
              lastAppEntryDate: data["lastAppEntryDate"],
              email: data["email"],
              password: data["password"],
            ),
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
