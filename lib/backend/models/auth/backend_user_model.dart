import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tattoo/core/base/models/base_model.dart';
import 'package:tattoo/core/extensions/map_extension.dart';

import '../../../domain/models/auth/user_model.dart';
import '../../core/encrypt/core_encrypt.dart';

class BackendUserModel extends BaseModel<BackendUserModel> {
  String? id;
  String? email;
  String? password;
  int? balance;
  Timestamp? createdDate;
  Timestamp? lastAppEntryDate;

  BackendUserModel({
    this.id,
    this.email,
    this.password,
    this.balance,
    this.createdDate,
    this.lastAppEntryDate,
  });

  BackendUserModel.from({required UserModel userModel}) {
    id = userModel.id;
    email = userModel.email;
    password = userModel.password != null
        ? CoreEncrypt().cryptFile(userModel.password!)
        : null;
    balance = userModel.balance;
    createdDate = userModel.createdDate != null
        ? Timestamp.fromDate(userModel.createdDate!)
        : null;
    lastAppEntryDate = userModel.lastAppEntryDate != null
        ? Timestamp.fromDate(userModel.lastAppEntryDate!)
        : null;
  }

  UserModel to({required BackendUserModel userModel}) {
    return UserModel(
      id: userModel.id,
      email: userModel.email,
      password: userModel.password,
      balance: userModel.balance,
      createdDate: userModel.createdDate != null ? createdDate?.toDate() : null,
      lastAppEntryDate: userModel.lastAppEntryDate != null
          ? lastAppEntryDate?.toDate()
          : null,
    );
  }

  @override
  BackendUserModel fromJson(Map<String, dynamic> json) {
    return BackendUserModel(
      id: json["id"],
      email: json["email"],
      password: json["password"],
      balance: json["balance"],
      createdDate: json["createdDate"],
      lastAppEntryDate: json["lastAppEntryDate"],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.putIfNotNull("email", email);
    map.putIfNotNull("password", password);
    map.putIfNotNull("balance", balance);
    map.putIfNotNull("createdDate", createdDate);
    map.putIfNotNull("lastAppEntryDate", lastAppEntryDate);

    return map;
  }
}