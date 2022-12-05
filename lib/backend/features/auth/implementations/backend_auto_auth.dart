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
  Future<BaseResponse<UserModel>> createUser(UserModel userModel) async {
    try {
      BackendUserModel backendUserModel =
          BackendUserModel.from(userModel: userModel);

      backendUserModel.balance = 30;
      backendUserModel.createdDate = Timestamp.now();
      backendUserModel.lastAppEntryDate = Timestamp.now();

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
}
